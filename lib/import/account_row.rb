require_relative 'charge_code'
require_relative 'errors'

module DB
  class AccountRow
    def initialize row
      @row = row
    end

    def human_ref
      @row[:human_ref].to_i
    end

    def charge_code
      @row[:charge_code]
    end

    def balance?
      charge_code == 'Bal'
    end

    def credit?
      credit  != 0
    end

    def debit?
      debit != 0
    end

    def on_date
      Date.parse @row[:on_date]
    end

    def amount
      debit? ? debit : credit
    end

    def account_id
      Property.find_by!(human_ref: human_ref).account.id
      rescue ActiveRecord::RecordNotFound
        raise DB::PropertyRefUnknown, property_unknown_message, caller
    end

    def method_missing method_name, *args, &block
      @row.send method_name, *args, &block
    end

    def respond_to_missing? method_name, include_private = false
      @row.respond_to?(method_name, include_private) || super
    end

    private

    def credit
      @row[:credit].to_f
    end

    def debit
      @row[:debit].to_f
    end

    def property_unknown_message
      "Property ref: #{human_ref} is unknown."
    end
  end
end
