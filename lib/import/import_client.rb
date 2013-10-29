require_relative 'import_base'
require_relative 'import_contact'
require_relative 'patch'

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

    def initialize  contents, patch
      super Client, contents, patch
    end

    def model_assignment
      @model_to_assign.assign_attributes human_ref: row[:human_ref]
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

  end
end
