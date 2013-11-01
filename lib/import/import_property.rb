require_relative 'import_base'
require_relative 'import_contact'

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

    def initialize  contents, patch
      super Property, contents, patch
    end

    def find_model model_class
      model_class.where human_ref: row[:human_ref]
    end

    def model_assignment
      @model_to_assign.assign_attributes \
        human_ref:  row[:human_ref],
        client_id: client_foreign_key_from_human_ref(row[:client_id])
      @model_to_assign.billing_profile.use_profile = false \
        if @model_to_assign.new_record?
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

    private

    def client_foreign_key_from_human_ref human_ref
      client_id_2_id.fetch human_ref.to_i
    end

    def client_id_2_id
      @client_id_2_id ||= Hash[*find_client_human_ref_to_id.flatten]
    end

    def find_client_human_ref_to_id
      @client_human_ref_to_id ||= Client.pluck(:human_ref, :id)
    end

  end
end
