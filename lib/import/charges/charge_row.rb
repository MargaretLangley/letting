require_relative '../../modules/method_missing'
require_relative '../charge_code'
require_relative '../errors'
require_relative 'charged_in_fields'
# rubocop: disable Rails/Output
# rubocop: disable Style/MethodCallParentheses

module DB
  #####
  #
  # ChargeRow
  #
  # Provides a cleaner interface to the charge field data.
  #
  # The charge import process takes rows of acc_info.csv and creates database
  # rows in the charges table. ImportCharge initializes this object and asks
  # for charge data from it. This object is providing a smoother interface
  # for the process - a layer of indirection between CSV and ImportCharge.
  #
  #####
  #
  class ChargeRow
    include MethodMissing

    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref].to_i
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      fail ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def charged_in_id
      ChargedInFields.new(charged_in_code: charged_in_code,
                          charge_type: charge_type)
                     .id
      rescue KeyError
        raise ChargedInCodeUnknown, charged_in_code_message, caller
    end

    def cycle_id
      CycleMatcher.new(day_months: day_months).id
      rescue CycleUnknown
        warn "Property #{human_ref} charge row does not match a charge cycle" \
          " (For legacy charge_type: '#{charge_code}') "
    end

    def amount
      @source[:amount].to_f
    end

    # Provides a way of cycle_matcher to access all the dates
    # that the charge are invoiced - allowing a cycle matching.
    def day_months
      return create_monthly_dates day(1) if monthly?
      return mid_term_day_months if charged_in_id == 3
      day_months = []
      1.upto(maximum_dates) do |index|
        break if empty_due_on? day(index), month(index)
        day_months << [day(index), month(index)]
      end
      day_months
    end

    def attributes
      {
        charge_type: charge_type,
        charged_in_id: charged_in_id,
        cycle_id: cycle_id,
        amount: amount,
        start_date: start_date,
        end_date: end_date,
      }
    end

    private

    # cycle_matcher requires charge_code as 'M' (momth) is a speical case
    def monthly?
      charge_code == 'M'
    end

    def create_monthly_dates day_of_the_month
      (1..12).each.map { |month| [day_of_the_month, month] }
    end

    # Legacy data defined charged_in Mid-Term to override the meaning of
    # due-dates. The due dates then became the billing period range.
    # This returns the meaning of the due_dates to be the same for mid-term
    # as any other charge. (DueDate is the date which a charge becomes due)
    def mid_term_day_months
      [[25, 3], [29, 9]]
    end

    def maximum_dates
      max_dates = ChargeCode.day_month_pairs charge_code
      fail ChargeCodeUnknown, max_dates_message, caller unless max_dates
      max_dates
    end

    def charge_code
      @source[:charge_type]
    end

    def day number
      @source[:"day_#{number}"].to_i
    end

    def month number
      @source[:"month_#{number}"].to_i
    end

    # most due_ons use empty day month pairing of (0,0)
    # a few, e.g. 7022, use (0,-1)
    def empty_due_on? day, month
      day.zero? && month.zero? || day.zero? && month == -1
    end

    def charged_in_code
      @source[:charged_in]
    end

    def start_date
      Date.parse MIN_DATE  # initializers/app_constants
    end

    def end_date
      Date.parse MAX_DATE # initializers/app_constants
    end

    def charge_code_message
      "Property #{human_ref}: Charge code #{charge_code} is unknown."
    end

    def max_dates_message
      "Property #{human_ref}: Charge code #{charge_code} " \
      'can not be converted into maximum dates per year.'
    end

    def charged_in_code_message
      "Property #{human_ref}: charged in code #{charged_in_code} is unknown."
    end
  end
end
