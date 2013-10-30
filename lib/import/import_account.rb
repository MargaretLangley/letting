require_relative 'import_base'
require_relative 'account_row'
require_relative 'creditable_amount'

module DB
  ####
  #
  # ImportAccount
  #
  #
  ####
  #

  class ImportPayment

  end




  class ImportAccount < ImportBase

    def initialize contents, patch
      super Property, contents, patch
    end

    def row= row
      @row = AccountRow.new(row)
    end

    def model_prepared
      change_model_to_save unless eq_ref? @model_to_save, row
      @model_to_assign = model_to_assign
    end

    def model_assignment
      if row.debits?
        @model_to_assign.attributes = row.attributes
        charges = ChargesMatcher.new @model_to_save.account.charges
        @model_to_assign.charge_id = charges.find!(row.charge_type).id
      else
        @model_to_assign.each do |model|
          model.attributes = row.attributes
          model.amount = @amount.max_withdrawal model.outstanding
          @amount.withdraw model.amount
        end
      end
    end

    private

    def change_model_to_save
      @model_to_save = parent_model Property
      @amount = CreditableAmount.new(0)
    end

    def model_to_assign
      if row.debits?
        @model_to_save.account.debits.build
      else
        @amount.deposit row.amount
        @model_to_save.account.prepare_for_form
        @model_to_save.account.credits_for_unpaid_debits
      end
    end

    def eq_ref? human_ref, other_human_ref
      human_ref.present? && other_human_ref.present? &&
        human_ref.human_ref == other_human_ref.human_ref
    end
  end
end
