require_relative 'import_base'

module DB
  class ImportUser < ImportBase

    def initialize  contents, patch
      super User, contents, patch
    end

    def model_assigned_row_attributes row
      @model_to_assign.assign_attributes email:    row[:email],
                                         password: row[:password],
                                         password_confirmation: row[:password],
                                         admin:    row[:admin]
    end

    def model_prepared_for_import row
      @model_to_assign = first_or_initialize_model row, @klass
    end

    def first_or_initialize_model row, model_class
      model_class.where(email: row[:email]).first_or_initialize
    end

  end
end
