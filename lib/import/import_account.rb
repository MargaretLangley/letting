require_relative 'import_base'
require_relative 'account_row'
require_relative 'import_debit'
require_relative 'import_payment'

module DB
  ####
  #
  # ImportAccount
  #
  # Wrapps around an account item - which is read in from the imported
  # legacy file acc_items (account items). ImportBase is responsible
  # for the generic calls and ImportAccount uses Charge, ImportDebit and
  # ImportPayment to wrap up the data.
  #
  # Charge is called when a new (mostly) debit is seen for the first time.
  # Debit is called when the account is to be debited by a charge.
  # Credit is called when the account is to be credited by a charge
  #
  # rubocop: disable Style/MethodLength
  ####
  #
  class ImportAccount < ImportBase
    def initialize  contents, range, patch
      super Property, contents, range, patch
    end

    def row= row
      @row = AccountRow.new(row)
    end

    # This should be in the account_row class
    # as we are asking about information and performing
    # actions - when all the time the information is in account_row
    #
    def import_row
      case
      when row.balance?
        import_balance if row.amount > 0
      when row.debit?
        ImportDebit.import [row]
      when row.credit?
        ImportPayment.import [row]
      else
        fail AccountRowTypeUnknown, account_type_unknown_msg
      end
    end

    def import_balance
      charge = Charge.new charge_type: 'Arrears',
                          charged_in: 'Arrears',
                          amount: row.amount,
                          account_id: row.account_id,
                          start_date: MIN_DATE,
                          end_date: MAX_DATE

      charge.due_ons.build day: row.on_date.day,
                           month: row.on_date.month,
                           year: row.on_date.year
      charge.save!
      ImportDebit.import [row]
    end

    def filtered?
      @range.exclude? row.human_ref
    end

    def account_type_unknown_msg
      "Unknown Row Property:#{row.human_ref}, charge_code: #{row.charge_code}"
    end
  end
end
