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
      @model_to_save = find_model!(Property).first
      @model_to_assign = @model_to_save.account.debits.build
    end

    def find_model model_class
      model_class.where human_ref: row[:human_ref]
    end

    def model_assignment
      @model_to_assign.attributes = row.attributes
      charges = ChargesMatcher.new @model_to_save.account.charges
      @model_to_assign.charge_id = charges.find!(row.charge_type).id
    end

  end
end
