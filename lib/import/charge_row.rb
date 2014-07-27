require_relative 'charge_code'
require_relative 'errors'
require_relative '../modules/method_missing'

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
    DUE_IN_CODE_TO_STRING  = { '0'  => 'Arrears',
                               '1' => 'Advance',
                               'M' => 'MidTerm' }
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

    def due_in
      DUE_IN_CODE_TO_STRING.fetch(due_in_code)
      rescue KeyError
        raise DueInCodeUnknown, due_in_code_message, caller
    end

    def day number
      @source[:"day_#{number}"].to_i
    end

    def month number
      @source[:"month_#{number}"].to_i
    end

    def attributes
      {
        charge_type: charge_type,
        due_in: due_in,
        amount: amount,
        start_date: start_date,
        end_date: end_date,
      }
    end

    private

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
  end
end
