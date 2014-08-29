module DB
  ####
  # PatchModel
  #
  # Holds the information used to correct models which contain incorrect data.
  #
  #
  # Patch.rb reads in patch files and creates a collection of PatchModels -
  # these objects. The models can then match and update models with 'wrong'
  # information during the general import.
  #
  # see patch.rb for more information
  #
  # rubocop: disable Rails/Output
  ###
  #
  class PatchModel
    def initialize model
      @model = model
    end

    def human_ref
      @model.human_ref
    end

    def changed? patchee_model
      changed = (@model.entities[0].name != patchee_model.entities[0].name)
      # Import is not a rails app and should not go to logger
      # Comment not at top because I want violation for not
      # documenting class
      puts changed_message patchee_model if changed
      changed
    end

    def patch patchee_model
      patchee_model.address.attributes =
        @model.address.copy_approved_attributes
    end

    private

    def changed_message model
      "Cannot match #{@model.class} #{human_ref} names between " \
      'the loading data and the patch data. Until ' \
      "'#{@model.entities[0].name}' is the same as " \
      "'#{model.entities[0].name} we cannot patch the address data."
    end
  end
end
