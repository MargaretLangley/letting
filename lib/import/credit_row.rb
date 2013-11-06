require_relative 'charge_code'
require_relative 'errors'

module DB

  class CreditRow
    def initialize row
      @row = row
    end

    def human_ref
      @row[:human_ref]
    end

    def charge_code
      @row[:charge_code]
    end

    def on_date
      @row[:on_date]
    end

    def amount
      @row[:credit].to_f
    end

    def account_id
      Property.find_by!(human_ref: human_ref).account.id
      rescue ActiveRecord::RecordNotFound
        raise DB::PropertyRefUnknown, property_unknown_message, caller
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      raise DB::ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def payment_attributes
      {
        account_id: account_id,
        on_date: on_date,
        amount: amount,
      }
    end

    def credit_attributes
      {
        on_date: on_date,
        amount: amount,
      }
    end

    def method_missing method_name, *args, &block
      @row.send method_name, *args, &block
    end

    def respond_to_missing? method_name, include_private = false
      @row.respond_to?(method_name, include_private) || super
    end

    def identity
      "Property: #{human_ref}, Charge code: #{charge_code}, Date: #{on_date}"
    end

    private


    def charge_code_message
      "#{identity} - #{charge_code} can not be converted into a string"
    end

    def property_unknown_message
      "Property ref: #{human_ref} is unknown."
    end

  end
end