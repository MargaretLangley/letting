require_relative 'charge_code'
require_relative 'errors'

module DB

  class ChargeRow

    DUE_IN_CODE_TO_STRING  = { '0'  => 'Arrears',
                               '1' => 'Advance',
                               'M' => 'MidTerm' }

    def initialize row
      @row = row
    end

    def human_ref
      @row[:human_ref]
    end

    def monthly_charge?
      month(1) == 0
    end

    def amount
      @row[:amount].to_f
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      raise ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def maximum_dates
      max_dates = ChargeCode.to_times_per_year charge_code
      raise ChargeCodeUnknown, max_dates_message, caller unless max_dates
      max_dates
    end

    def due_in
      DUE_IN_CODE_TO_STRING.fetch(due_in_code)
      rescue KeyError
        raise DueInCodeUnknown, due_in_code_message, caller
    end

    def day number
      @row[:"day_#{number}"].to_i
    end

    def month number
      @row[:"month_#{number}"].to_i
    end

    def attributes
      {
        charge_type: charge_type,
        due_in: due_in,
        amount: amount,
      }
    end

    def method_missing method_name, *args, &block
      @row.send method_name, *args, &block
    end

    def respond_to_missing? method_name, include_private = false
      @row.respond_to?(method_name, include_private) || super
    end

    private

    def charge_code
      @row[:charge_type]
    end

    def due_in_code
      @row[:due_in]
    end

    def charge_code_message
      "Property #{human_ref}: Charge code #{charge_code} can not be converted into a string"
    end

    def max_dates_message
      "Property #{human_ref}: Charge code #{charge_code} can not be converted into maximum dates per year."
    end

    def due_in_code_message
      "Property #{human_ref}: Due in code #{due_in_code} is unknown."
    end

  end
end
