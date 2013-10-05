
require_relative 'import_base'

module DB

  ####
  #
  # Imports users into the application.
  #
  # The source code is freely available on the internet. We require that
  # user information is private and not kept with the source code.
  # The user information is kept in a CSV file.
  #
  # The code is run only during the import process.
  #
  # CSV was chosen because the system uses it for all the other database
  # tables already.
  #
  ####
  #
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
