require_relative '../modules/method_missing'
require_relative 'charge_code'
require_relative 'errors'

module DB
  class CreditRow
    include MethodMissing

    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref]
    end

    def charge_code
      @source[:charge_code]
    end

    def on_date
      @source[:on_date]
    end

    def amount
      @source[:credit].to_f
    end

    def account_id
      Property.find_by!(human_ref: human_ref).account.id
      rescue ActiveRecord::RecordNotFound
        raise DB::PropertyRefUnknown, property_unknown_message, caller
    end

    def charge_id
      Charge.find_by!(account_id: account_id, charge_type: charge_type).id
      rescue ActiveRecord::RecordNotFound
        raise DB::ChargeUnknown, charge_unknown(account_id, charge_type), caller
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      fail DB::ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def payment_attributes
      {
        account_id: account_id,
        on_date: on_date,
        amount: amount,
      }
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

    def charge_unknown account_id, charge_type
      "Charge with account: #{account_id} charge_type: #{charge_type} "
    end
  end
end
