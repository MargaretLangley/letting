require_relative '../modules/method_missing'
require_relative 'charge_code'
require_relative 'errors'
require_relative 'accounting_row'

module DB
  ####
  #
  # BalanceRow
  #
  # Wraps around an imported row of data.
  #
  ####
  #
  class BalanceRow
    include MethodMissing
    include AccountingRow

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
      @source[:on_date].to_datetime
    end

    def description_to_charge
      return 'Service Charge' if @source[:description].include?('Service') ||
                                 @source[:description].include?('SC')
      return 'Garage Ground Rent' if @source[:description].include? 'Garage'
    end

    # debits increase an account balance.
    # debits amounts are positive (+)
    #
    def amount
      debit
    end

    def charge_id
      row_charge.id
    end

    def next_on_date
      row_charge.coming(on_date..on_date + 1.year)
        .first
        .on_date
    end

    def charge_type
      if charge_code == 'Bal'
        charge_type = description_to_charge
        charge_type = account(human_ref: human_ref).charges.first.charge_type \
          if charge_type.blank?
        charge_type
      else
        charge_code_to_s charge_code: charge_code, human_ref: human_ref
      end
    end

    def period
      MIN_DATE..on_date
    end

    def attributes
      {
        charge_id: charge_id,
        on_date: next_on_date,
        period: period,
        amount: amount,
      }
    end

    def message
      "Property #{human_ref} charge_code: #{charge_code}"
    end

    private

    def row_charge
      charge account: account(human_ref: human_ref),
             charge_type: charge_type
    end

    def debit
      @source[:debit].to_f
    end
  end
end
