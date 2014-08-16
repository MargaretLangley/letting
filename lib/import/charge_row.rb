require_relative 'charge_code'
require_relative 'errors'
require_relative '../modules/method_missing'
# rubocop: disable Rails/Output

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
    # Mapping of imported values to application values
    # Definitive values charged_in.csv/charged_ins table;
    DUE_IN_CODE_TO_STRING  = { '0'  => 1,     # Arrears
                               '1' =>  2,     # Advance
                               'M' =>  3 }    # Mid_term
    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref]
    end

    def monthly_charge?
      month(1) == 0
    end

    def amount
      @source[:amount].to_f
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      fail ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def maximum_dates
      max_dates = ChargeCode.to_times_per_year charge_code
      fail ChargeCodeUnknown, max_dates_message, caller unless max_dates
      max_dates
    end

    def charged_in_id
      DUE_IN_CODE_TO_STRING.fetch(due_in_code)
      rescue KeyError
        raise DueInCodeUnknown, due_in_code_message, caller
    end

    def charge_structure_id
      ChargeStructureMatcher.new(self).id
      rescue ChargeStuctureUnknown
        puts property_message +
          ' charge row does not match a charge structure'
    end

    def each
      1.upto(4) do |index|
        break if empty_due_on? day(index), month(index)
        yield day(index), month(index)
      end
    end

    def attributes
      {
        charge_type: charge_type,
        charge_structure_id: charge_structure_id,
        amount: amount,
        start_date: start_date,
        end_date: end_date,
      }
    end

    private

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

    def due_in_code
      @source[:due_in]
    end

    def start_date
      Date.parse MIN_DATE  # initializers/app_constants
    end

    def end_date
      Date.parse MAX_DATE # initializers/app_constants
    end

    def charge_code_message
      "Property #{human_ref}: " \
      "Charge code #{charge_code} can not be converted into a string"
    end

    def max_dates_message
      "Property #{human_ref}: Charge code #{charge_code} " \
      'can not be converted into maximum dates per year.'
    end

    def due_in_code_message
      "Property #{human_ref}: Due in code #{due_in_code} is unknown."
    end

    def property_message
      "Property #{human_ref}"
    end
  end
end
