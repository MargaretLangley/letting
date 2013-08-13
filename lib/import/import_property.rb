require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportProperty  < ImportBase

    def do_it
      contents.each_with_index do |row, index|
        model = model_prepared_for_import row, Property
        model_assigned_row_attributes model, row
        output_error row, model unless model.save
        output_still_running index
      end
    end

    def model_assigned_row_attributes model, row
      model.assign_attributes human_id: row[:human_id], client_id: row[:clientid]
      model.billing_profile.use_profile = false if model.new_record?
      import_contact model, row
      clean_contact model
    end

    def address_type contactable
      contactable.human_id.to_i > 6000 ? 'FlatAddress' : 'HouseAddress'
    end

  end
end
