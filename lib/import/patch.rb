require_relative 'patch_model'
require_relative 'contact_fields'

module DB
  ####
  #
  # Patch
  #
  # Overrides data in models that needs updating but we are unable to update
  # source.
  #
  # Some of the legacy data is incorrect but we are unable to change the source
  # database. A solution to this is to 'patch' (correct) the incoming data.
  #
  # There are a number of patch files - one for each set of models that requires
  # an update.
  #
  # Patch runs ahead of the import_base process - allowing the system to create
  # a collection of models that need to be changed. These are presented to the
  # import_base system and can be used to update matching models.
  #
  # Currently, this updates client and agent data
  #
  ####
  #
  class Patch
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
      ContactFields.new(row).update_for @model_to_assign
    end

    def patch_models_add
      @patch_models << PatchModel.new(@model_to_assign)
    end

    def patch_model model
      patch_model = find_patched_model model
      return if patch_model.nil? || patch_model.changed?(model)
      patch_model.patch model
    end

    private

    def find_patched_model model
      @patch_models.find do |patch_model|
        patch_model.human_ref == model.human_ref
      end
    end
  end
end
