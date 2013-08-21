require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportProperty  < ImportBase

    def initialize  contents, patch
      super Property, contents, patch
    end

    def model_assigned_row_attributes row
      @model_to_assign.assign_attributes human_id: row[:human_id], client_id: row[:clientid]
      @model_to_assign.billing_profile.use_profile = false if @model_to_assign.new_record?
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end

  end
end
