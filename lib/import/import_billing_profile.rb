require_relative 'import_base'
require_relative 'import_contact'

module DB
  ####
  #
  # ImportBillingProfile
  #
  # Imports billing profiles (shipping addreses for properties)
  #
  # Uses ImportBase and is called during the import process and at no
  # other time.
  #
  ####
  #
  class ImportBillingProfile < ImportBase
    def initialize  contents, range, patch
      super BillingProfile, contents, range, patch
    end

    def model_prepared
      @model_to_save = find_model!(Property).first
      @model_to_save.prepare_for_form
      @model_to_assign = BillingProfileWithId.new \
                           @model_to_save.billing_profile
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
      @model_to_assign.assign_attributes use_profile: true
      @model_to_assign.human_ref = row[:human_ref].to_i
      import_contact @model_to_assign, row
      clean_contact @model_to_assign
    end
  end
end
