require_relative '../modules/method_missing'
require_relative 'charge_code'
require_relative 'errors'

module DB
  class AccountRow
    include MethodMissing

    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref].to_i
    end

    def charge_code
      @source[:charge_code]
    end

    def balance?
      charge_code == 'Bal'
    end

    def credit?
      credit  != 0
    end

    def debit?
      debit != 0 || credit < 0
    end

    def on_date
      Date.parse @source[:on_date]
    end

    def amount
      debit? ? debit : credit
    end

    def account_id
      Property.find_by!(human_ref: human_ref).account.id
      rescue ActiveRecord::RecordNotFound
        raise DB::PropertyRefUnknown, property_unknown_message, caller
    end

    private

    def credit
      @source[:credit].to_f
    end

    def debit
      @source[:debit].to_f
    end

    def property_unknown_message
      "Property ref: #{human_ref} is unknown."
    end
  end
end
