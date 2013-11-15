require_relative 'credit_row'
require_relative 'import_base'
require_relative 'creditable_amount'

module DB
  class ImportPayment < ImportBase
    def initialize contents, range, patch
      super Payment, contents, range, patch
      @amount = CreditableAmount.new(0)
    end

    def row= row
      @row = CreditRow.new(row)
    end

    def model_prepared
      @model_to_assign = find_model(@klass).first_or_initialize
      @model_to_assign.prepare
      fail DB::NotIdempotent, import_not_idempotent_msg, caller \
        unless @model_to_assign.new_record?
    end

    def find_model model_class
      model_class.where account_id: row.account_id, on_date: row.on_date
    end

    def model_assignment
      @amount.deposit row.amount
      @model_to_assign.attributes = row.payment_attributes
      model_assignment_credits
    end

    def model_assignment_credits
      @model_to_assign.credits.each do |credit|
        credit.amount = (@amount.max_withdrawal credit.pay_off_debit).round(2)
        @amount.withdraw credit.amount
      end
    end

    def import_not_idempotent_msg
      "#{row.identity}: Import Process for #{self.class} is not idempodent." +
      ' You need to delete Payment and credits before running this task again.'
    end
  end
end
