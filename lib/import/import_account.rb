require_relative 'import_base'
require_relative 'account_row'
require_relative 'creditable_amount'
require_relative 'import_debit'
require_relative 'import_payment'

module DB
  ####
  #
  # ImportAccount
  #
  #
  ####
  #

  class ImportAccount < ImportBase
    def initialize  contents, range, patch
      super Property, contents, range, patch
    end

    def row= row
      @row = AccountRow.new(row)
    end

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
                          due_in: 'Arrears',
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

    def filtered_condition
      @range.exclude? row.human_ref
    end

    def account_type_unknown_msg
      "Unknown Row Property:#{row.human_ref}, charge_code: #{row.charge_code}"
    end
  end
end
