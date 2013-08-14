require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportBillingProfile < ImportBase

    def do_it
      contents.each_with_index do |row, index|
        property = model_prepared_for_import row, Property
        model = property.billing_profile
        model_assigned_row_attributes model, row
        output_error row, model unless model.save
        output_still_running index
      end
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
