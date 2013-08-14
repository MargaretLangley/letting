module DB
  class Patch
    include ImportContact
    attr_reader :model_class
    attr_reader :patch_contents
    attr_reader :patch_models

    def initialize model_class, patch_contents = []
      @model_class = model_class
      @patch_contents = patch_contents
      @patch_models = []
    end

    def self.import model_class, patch_contents
      patch = new(model_class, patch_contents)
      patch.build_patching_models
      patch
    end

    def build_patching_models
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


    def patch_model model
      model_hash = patch_models.detect { |m| m['id'] == model.human_id }
      if model_hash.present?
        patch_model = model_hash['model']
        if entity_names_match? model, patch_model
          # Address types are a pain since they have to be calculated
          # Not stored in the data
          patch_model.address.type = model.address.type
          patch_address model, patch_model
        else
          puts none_matching_entities_error_message model, patch_model
        end
      end
    end

    private

      def address_type row
        'DoNotUse'
      end

      def entity_names_match? model, patch_model
        model.entities[0].name == patch_model.entities[0].name
      end

      def patch_address model, patch_model
        model.address = patch_model.address
      end

      def none_matching_entities_error_message model, patch_model
        "Cannot match #{model.class} #{patch_model.human_id} names." +
        "between the loading data and the patch data." +
        " Until '#{patch_model.entities[0].name}' " +
        "is the same as '#{model.entities[0].name}' we cannot patch the address data."
      end

  end
end