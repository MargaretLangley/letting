require_relative 'import_base'
require_relative 'import_contact'
require_relative 'property_row'

module DB
  ####
  # ImportProperty
  #
  # Import of Property data into the database.
  #
  # How does this fit into the larger system?
  #
  # Imported data is read by FileImport and presented to ImportProperty as
  # array of arrays. The base classj, ImportBase, handles the data source
  # and iterrates through the array in a loop. ImportProperty overrides
  # the assignment but otherwise the base gets a model, assigns attributes
  # and saves the model to the database for all rows.
  #
  ####
  #
  class ImportProperty  < ImportBase
    def initialize  contents, range, patch
      super Property, contents, range, patch
    end

    def row= row
      @row = PropertyRow.new(row)
    end

    def model_prepared
      super
      @model_to_assign.prepare_for_form
    end

    def find_model model_class
      model_class.where human_ref: row.human_ref
    end

    # true filters
    # false allows
    #
    def filtered_condition
      @range.exclude? row.human_ref
    end

    def model_assignment
      @model_to_assign.assign_attributes human_ref: row.human_ref,
                                         client_id: row.client_id
      @model_to_assign.billing_profile.use_profile = false if model_is_new
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

    def model_is_new
      @model_to_assign.new_record?
    end
  end
end
