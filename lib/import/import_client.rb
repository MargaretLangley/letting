require_relative 'import_base'
require_relative 'import_contact'

module DB
  ####
  #
  # ImportClient
  #
  # Load and assigns, and saves client models into the database.
  #
  ####
  #
  class ImportClient < ImportBase

    def initialize  contents, range, patch
      super Client, contents, range, patch
    end

    def model_prepared
      super
      @model_to_assign.prepare_for_form
    end

    def find_model model_class
      model_class.where human_ref: row[:human_ref]
    end

    def model_assignment
      @model_to_assign.assign_attributes human_ref: row[:human_ref]
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

  end
end
