require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportClient < ImportBase

    def do_it
      build_patching_models Client

      contents.each_with_index do |row, index|
        model = model_prepared_for_import row, Client
        model_assigned_row_attributes model, row
        model_patched model
        output_error row, model unless model.save
        output_still_running index
      end
    end

    def build_patching_models model_class
      patch_contents.each do |row|
        model = model_class.new human_id: row[:human_id]
        model.prepare_for_form
        model_assigned_row_attributes model, row
        patch_models << { 'id' => model.human_id, 'model' => model }
      end
    end

    def model_assigned_row_attributes model, row
      model.assign_attributes human_id: row[:human_id]
      import_contact model, row
      clean_contact model
    end

    def address_type contactable
      'FlatAddress'
    end

    def model_patched model
      model_hash = patch_models.detect { |m| m['id'] == model.human_id }
      if model_hash.present?
        patch_model = model_hash['model']
        if entity_names_match? model, patch_model
          patch_address model, patch_model
        else
          puts none_matching_entities_error_message model, patch_model
        end
      end
    end

    def entity_names_match? model, patch_model
      model.entities[0].name == patch_model.entities[0].name
    end

    def patch_address model, patch_model
      model.address = patch_model.address
    end
  end
end