require_relative 'credit_row'
require_relative 'import_base'

module DB
  ####
  #
  # ImportPayment
  #
  # Creates payments and builds associated credits from row file data.
  #
  # ImportPayment consumes account information, acc_items.csv, and
  # produces database records.
  #
  # Account process begins with ImportAccount, which contains both
  # opening balances, credits and debits, and this filters the row
  # into their bookkeeping taxonamy and feeds it to the appropriate
  # objects. ImportPayment is responsible for credits and will
  # create a payment and a credit from a row of file data.
  #
  ####
  #
  class ImportPayment < ImportBase
    def initialize contents, range, patch
      super Payment, contents, range, patch
    end

    def row= row
      @row = CreditRow.new(row)
    end

    def model_prepared
      @model_to_assign = Payment.where(account_id: row.account_id,
                                       on_date: row.on_date).first_or_initialize
      fail DB::NotIdempotent, import_not_idempotent_msg, caller \
        unless @model_to_assign.new_record?
    end

    def model_assignment
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

    def import_not_idempotent_msg
      "#{row.human_ref}: Import Process for #{self.class} is not idempodent." \
      ' You need to delete Payment and credits before running this task again.'
    end
  end
end
