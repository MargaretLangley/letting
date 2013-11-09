require_relative 'charge_code'
require_relative 'errors'

module DB
  class DebitRow
    def initialize row
      @row = row
    end

    def human_ref
      @row[:human_ref]
    end

    def amount
      debit
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      fail DB::ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def charge_id
      property = Property.find_by(human_ref: human_ref)
      fail DB::PropertyRefUnknown, property_unknown_message, caller \
        unless property
      charge = Charge.find_by account_id: property.account.id,
                              charge_type: charge_type
      fail DB::ChargeUnknown, charge_unknown_message, caller unless charge
      charge.id
    end

    def attributes
      {
        charge_id: charge_id,
        on_date: on_date,
        amount: amount,
        debit_generator_id: -1,
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
      @row[:charge_code]
    end

    def on_date
      @row[:on_date]
    end

    def debit
      @row[:debit].to_f
    end

    def charge_code_message
      "Property #{human_ref}: " +
      "Charge code #{charge_code} can not be converted into a string"
    end

    def property_unknown_message
      "Property ref: #{human_ref} is unknown."
    end

    def charge_unknown_message
      "Charge '#{charge_type}' not found in property " +
      "'#{human_ref || 'unknown' }'"
    end
  end
end
