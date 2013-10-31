require_relative 'import_base'
require_relative 'account_row'

module DB
  class ImportDebit < ImportBase

    def initialize contents, patch
      super Property, contents, patch
    end

    def row= row
      @row = AccountRow.new(row)
    end

    def model_prepared
      change_model_to_save
      @model_to_assign = model_to_assign
    end

    def model_assignment
      @model_to_assign.attributes = row.attributes
      charges = ChargesMatcher.new @model_to_save.account.charges
      @model_to_assign.charge_id = charges.find!(row.charge_type).id
    end

    def change_model_to_save
      @model_to_save = parent_model Property
    end

    private

    def model_to_assign
      @model_to_save.account.debits.build
    end

  end
end
