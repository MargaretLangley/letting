require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportProperty  < ImportBase

    def initialize  contents, patch
      super Property, contents, patch
    end

    def client_foreign_key_from_human_id human_id
      client_id_2_id.fetch human_id.to_i
    end


    def model_assigned_row_attributes row
      @model_to_assign.assign_attributes human_id: row[:human_id], \
        client_id: client_foreign_key_from_human_id(row[:client_id])
      @model_to_assign.billing_profile.use_profile = false if @model_to_assign.new_record?
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

    private

    def client_id_2_id
      @client_id_2_id ||= Hash[*find_client_human_id_to_id.flatten]
    end

    def find_client_human_id_to_id
      @client_human_id_to_id ||= Client.pluck(:human_id,:id)
    end

  end
end
