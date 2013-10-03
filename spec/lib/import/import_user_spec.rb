require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_fields'
require_relative '../../../lib/import/import_charge'
require_relative '../../../lib/import/import_user'

module DB
  describe ImportUser do
    it 'One row' do
      expect { ImportUser.import users_csv_table }.to change(User, :count).by 1
    end

    it 'Not double import' do
      ImportUser.import users_csv_table
      expect { ImportUser.import users_csv_table }.to_not change(Charge, :count)
    end

    def users_csv_table
      Import.csv_table('users',
                       headers: ImportFields.user,
                       location: 'spec/fixtures/import_data/users')
    end

  end
end
