require_relative 'charge_code'
require_relative 'errors'
require_relative 'charged_in_fields'
require_relative '../modules/method_missing'
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
    include Enumerable

    def initialize row
      @source = row
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      fail ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def charged_in_id
      ChargedInFields.new(charged_in_code: charged_in_code, charge_type: charge_type).id
      rescue KeyError
        raise ChargedInCodeUnknown, charged_in_code_message, caller
    end

    def charge_cycle_id
      ChargeCycleMatcher.new(self).id
      rescue ChargeCycleUnknown
        puts "Property #{human_ref} charge row does not match a charge cycle" \
          " Legacy charge_type: '#{charge_code}' "
    end

    def amount
      @source[:amount].to_f
    end

    def each
      1.upto(maximum_dates) do |index|
        break if empty_due_on? day(index), month(index)
        yield day(index), month(index)
      end
    end

    def attributes
      {
        charge_type: charge_type,
        charged_in_id: charged_in_id,
        charge_cycle_id: charge_cycle_id,
        amount: amount,
        start_date: start_date,
        end_date: end_date,
      }
    end

    private

    def human_ref
       @source[:human_ref]
    end

    def maximum_dates
      max_dates = ChargeCode.to_times_per_year charge_code
      fail ChargeCodeUnknown, max_dates_message, caller unless max_dates
      max_dates
    end

    def day number
      @source[:"day_#{number}"].to_i
    end

    def month number
      @source[:"month_#{number}"].to_i
    end

    def empty_due_on? day, month
      day == 0 && month == 0
    end

    def charge_code
      @source[:charge_type]
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
