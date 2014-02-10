require_relative 'import_base'
require_relative 'contact_row'

module DB
  ####
  #
  # ImportAgent
  #
  # Imports agents (shipping addreses for properties)
  #
  # Uses ImportBase and is called during the import process and at no
  # other time.
  #
  ####
  #
  class ImportAgent < ImportBase
    def initialize  contents, range, patch
      super Agent, contents, range, patch
    end

    def model_prepared
      @model_to_save = find_model!(Property).first
      @model_to_save.prepare_for_form
      @model_to_assign = AgentWithId.new @model_to_save.agent
    end

    def find_model model_class
      model_class.where human_ref: row[:human_ref]
    end

    # true filters
    # false allows
    #
    def filtered_condition
      @range.exclude? row[:human_ref].to_i
    end

    def model_assignment
      @model_to_assign.assign_attributes authorized: true
      @model_to_assign.human_ref = row[:human_ref].to_i
      ContactRow.new(row).update_for @model_to_assign
    end
  end
end
