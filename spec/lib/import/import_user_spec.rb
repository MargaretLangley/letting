require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_fields'
require_relative '../../../lib/import/import_charge'
require_relative '../../../lib/import/import_user'

module DB
  describe ImportUser do
    it 'One row' do
      property_factory
      expect{ ImportUser.import Import.csv_table('users', headers: ImportFields.user, location: 'spec/fixtures/import_data/users') }.to \
        change(User, :count).by 1
    end

    it 'Not double import' do
      property_factory
      ImportUser.import Import.csv_table('users', headers: ImportFields.user, location: 'spec/fixtures/import_data/users')
      expect{ ImportUser.import Import.csv_table('users', headers: ImportFields.user, location: 'spec/fixtures/import_data/users') }.to \
        change(Charge, :count).by 0
    end

  end
end

