require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/import_fields'
require_relative '../../../lib/import/import_charge'
require_relative '../../../lib/import/import_user'

module DB
  describe ImportUser do
    it 'One row' do
      expect { ImportUser.import users_file_to_arrays }.to \
        change(User, :count).by 1
    end

    it 'Not double import' do
      ImportUser.import users_file_to_arrays
      expect { ImportUser.import users_file_to_arrays }.to_not \
        change(Charge, :count)
    end

    def users_file_to_arrays
      FileImport.to_a('users',
                      headers: FileHeaders.user,
                      location: 'spec/fixtures/import_data/users')
    end

  end
end
