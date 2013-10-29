module DB
  ####
  #
  # Patch
  #
  # Overrides data in models that needs updating but we are unable to upudate
  # source.
  #
  # Currently, this updates client and billing_profile data
  # Note that calls import_contact which would need to be looked at if
  # the class didn't use contact.
  #
  # Called during the import process only. It updates only those read in
  # during build_patching models.
  #
  ####
  #
  class Patch
    include ImportContact
     attr_accessor :row

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
      @patch_contents.each do |row|
        self.row = row
        model_prepared_for_import
        patch_models_add
      end
    end

    def model_prepared_for_import
      @model_to_assign = @model_class.new
      @model_to_assign.human_ref = row[:human_ref].to_i
      @model_to_assign.prepare_for_form
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

    def patch_models_add
      @patch_models << { 'id'    => @model_to_assign.human_ref,
                         'model' => @model_to_assign }
    end

    # debug hash array: patch_models[0]['model']
    def patch_model model
      model_hash = @patch_models.find { |m| m['id'] == model.human_ref }
      if model_hash.present?
        patch_model = model_hash['model']
        if entity_names_match? model, patch_model
          patch_address model, patch_model
        else
          puts none_matching_entities_error_message model, patch_model
        end
      end
    end

    private

      def entity_names_match? model, patch_model
        model.entities[0].name == patch_model.entities[0].name
      end

      def patch_address model, patch_model
        model.address.attributes =
          patch_model.address.copy_approved_attributes
      end

      def none_matching_entities_error_message model, patch_model
        "Cannot match #{model.class} #{patch_model.human_ref} names between " +
        'the loading data and the patch data. Until ' +
        "'#{patch_model.entities[0].name}' is the same as " +
        "'#{model.entities[0].name} we cannot patch the address data."
      end

  end
end
