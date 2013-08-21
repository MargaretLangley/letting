require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportBillingProfile < ImportBase

    def initialize  contents, patch
      super BillingProfile, contents, patch
    end

    # Returns Billing Profile model
    def model_prepared_for_import row
      property = first_or_initialize_model row, Property
      property.prepare_for_form
      @model_to_assign = property.billing_profile
    end

    def model_assigned_row_attributes row
      @model_to_assign.assign_attributes use_profile: true, human_id: row[:human_id].to_i
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

  end
end
