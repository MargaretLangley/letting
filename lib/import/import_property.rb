require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportProperty  < ImportBase

    def initialize  contents, patch
      super Property, contents, patch
    end

    def model_assigned_row_attributes model, row
      model.assign_attributes human_id: row[:human_id], client_id: row[:clientid]
      model.billing_profile.use_profile = false if model.new_record?
      import_contact model, row
      clean_contact model
    end

  end
end
