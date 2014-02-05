require_relative 'import_contact'

module DB
  ####
  #
  # Patch
  #
  # Overrides data in models that needs updating but we are unable to upudate
  # source.
  #
  # Currently, this updates client and agent data
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
        model_prepared
        patch_models_add
      end
    end

    def model_prepared
      @model_to_assign = @model_class.new
      @model_to_assign.human_ref = row[:human_ref].to_i
      @model_to_assign.prepare_for_form
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

    def patch_models_add
      @patch_models << PatchModel.new(@model_to_assign)
    end

    def patch_model model
      patch_model = @patch_models.find { |m| m.human_ref == model.human_ref }
      return if patch_model.nil? || patch_model.changed?(model)
      patch_model.patch model
    end
  end
end
