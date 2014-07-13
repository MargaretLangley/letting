module DB
  class PatchModel
    def initialize model
      @model = model
    end

    def human_ref
      @model.human_ref
    end

    def changed? patchee_model
      changed = (@model.entities[0].name != patchee_model.entities[0].name)
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