require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportBillingProfile < ImportBase

    def initialize  contents, patch
      super BillingProfile, contents, patch
    end

    def model_prepared_for_import row
      @model_to_save = first_or_initialize_model row, Property
      @model_to_save.prepare_for_form
      @model_to_assign = @model_to_save.billing_profile
    end

    def model_assigned_row_attributes row
      @model_to_assign.assign_attributes use_profile: true, human_id: row[:human_id].to_i
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

  end
end