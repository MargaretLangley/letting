require_relative 'import_base'
require_relative 'import_contact'
require_relative 'patch'

module DB
  class ImportClient < ImportBase

    def do_it
      contents.each_with_index do |row, index|
        model = model_prepared_for_import row, Client
        model_assigned_row_attributes model, row
        patch.patch_model model if patch
        unless model.save
          output_error row, model
        end
        output_still_running index
      end
    end


    def model_assigned_row_attributes model, row
      model.assign_attributes human_id: row[:human_id]
      import_contact model, row
      clean_contact model
    end

    def address_type row
      'FlatAddress'
    end

  end
end