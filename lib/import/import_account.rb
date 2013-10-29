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


  class ImportAccount < ImportBase

    def initialize contents, patch
      super Property, contents, patch
    end

    def model_prepared_for_import row
      account_row = AccountRow.new(row)
      change_model_to_save account_row \
        unless eq_ref? @model_to_save, account_row
      @model_to_assign = model_to_assign row
    end

    def model_assignment row
      if AccountRow.new(row).debits?
        @model_to_assign.attributes = AccountRow.new(row).attributes
      else
        @model_to_assign.each do |model|
          model.attributes = AccountRow.new(row).attributes
          model.amount = @amount.max_withdrawal model.outstanding
          @amount.withdraw model.amount
        end
      end
    end

    private

    def change_model_to_save row
      @model_to_save = parent_model row, Property
      @amount = CreditableAmount.new(0)
    end

    def model_to_assign row
      if AccountRow.new(row).debits?
        @model_to_save.account.debits.build
      else
        @amount.deposit AccountRow.new(row).amount
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
