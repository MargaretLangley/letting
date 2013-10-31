require_relative 'credit_row'
require_relative 'import_base'
require_relative 'creditable_amount'

module DB
  class ImportPayment < ImportBase

    def initialize contents, patch
      super Payment, contents, patch
      @amount = CreditableAmount.new(0)
    end

    def row= row
      @row = CreditRow.new(row)
    end

    def model_assignment
      @amount.deposit row.amount
      @model_to_assign.attributes = row.payment_attributes
      @model_to_assign.account.prepare_for_form
      @model_to_assign.account.credits_for_unpaid_debits.each do |credit|
        credit.attributes = row.credit_attributes
        credit.amount = @amount.max_withdrawal credit.outstanding
        @model_to_assign.credits << credit
        @amount.withdraw credit.amount
      end
    end

    def find_model model_class
      model_class.where account_id: row[:account_id],
                        on_date: row[:on_date]
    end

  end
end
