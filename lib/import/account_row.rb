require_relative '../modules/method_missing'
require_relative 'charge_code'
require_relative 'errors'
require_relative 'accounting_row'

module DB
  ####
  #
  # AccountRow
  #
  # Wrapps around an imported row of data acc_items.
  #
  # Called during the Importing of accounts information.
  # ImportAccount assigns a row to AccountRow
  #
  # ** Next bit is aspirational **
  #
  # AccountRow knows the type responsible for importing the file row
  # - balance row, credit row or debit row and instantiates it.
  # The instantiated row is then responsbile for the remaining import.
  #
  ####
  #
  class AccountRow
    include MethodMissing
    include AccountingRow

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
      account(human_ref: human_ref).id
    end

    private

    def credit
      @source[:credit].to_f
    end

    def debit
      @source[:debit].to_f
    end
  end
end
