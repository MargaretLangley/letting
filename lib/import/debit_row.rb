require_relative '../modules/method_missing'
require_relative 'charge_code'
require_relative 'errors'
require_relative 'accounting_row'

module DB
  ####
  #
  # DebitRow
  #
  # Wrapps around an imported row of data.
  #
  # Called during the Importing of accounts information.
  # Debits are passed to ImportDebit and during the imported
  # row is wrapped with this DebitRow. During the importing
  # the data needs to relate to other imported rows, charges
  # in this case, and this is hides this behaviour from the
  # ImportDebit.
  #
  # Errors do not go to logger
  # rubocop: disable Rails/Output
  #
  ####
  #
  class DebitRow
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
      @source[:on_date]
    end

    def period
      charge(account: account(human_ref: human_ref),
             charge_type: charge_type)
        .period(billed_on: on_date.to_date)
    end

    # debits increase an account balance.
    # debits amounts are positive (+)
    #
    def amount
      debit
    end

    def charge_id
      charge(account: account(human_ref: human_ref),
             charge_type: charge_type).id
    end

    def charge_type
      charge_code_to_s(charge_code: charge_code,
                       human_ref: human_ref)
    end

    def attributes
      {
        charge_id: charge_id,
        on_date: on_date,
        period: period,
        amount: amount,
      }
    end

    private

    def debit
      debit = @source[:debit].to_f
      if negative_credit?
        puts "Property #{human_ref}: converting negative credit to debit"
        debit = credit * -1
      end
      debit
    end

    def negative_credit?
      credit < 0
    end

    def credit
      @source[:credit].to_f
    end
  end
end
