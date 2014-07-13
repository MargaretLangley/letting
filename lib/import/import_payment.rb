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
      @model_to_assign = @klass.new account_id: row.account_id,
                                    on_date: row.on_date
      fail DB::NotIdempotent, import_not_idempotent_msg, caller \
        unless @model_to_assign.new_record?
    end

    def model_assignment
      @amount.deposit row.amount
      @model_to_assign.attributes = row.payment_attributes
      model_assignment_credits
    end

    def model_assignment_credits
      @model_to_assign.credits.build account_id: row.account_id,
                                     charge_id: row.charge_id,
                                     on_date: row.on_date,
                                     amount: row.amount
    end

    private

    def find_credits_with_charge_type credits, charge_type
      credits.find { |credit| credit.charge_type == charge_type }
    end

    def charge_type_unknown
      "#{row.identity}: Cannot find charge type #{row.charge_type} in property"
    end

    def import_not_idempotent_msg
      "#{row.identity}: Import Process for #{self.class} is not idempodent." +
      ' You need to delete Payment and credits before running this task again.'
    end
  end
end
