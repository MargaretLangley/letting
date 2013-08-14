require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportBillingProfile < ImportBase

    def initialize  contents, patch
      super BillingProfile, contents, patch
    end

    def do_it
      contents.each_with_index do |row, index|
        model = model_prepared_for_import row
        model_assigned_row_attributes model, row
        patch.patch_model model if patch
        unless model.save
          output_error row, model
        end
        output_still_running index
      end
    end

    # Returns Billing Profile model
    def model_prepared_for_import row
      property = find_or_initialize_model row, Property
      property.prepare_for_form
      property.billing_profile
    end

    def model_assigned_row_attributes model, row
      model.assign_attributes use_profile: true
      import_contact model, row
      clean_contact model
    end


    def address_type row
      row[:human_id].to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
    end

  end
end
