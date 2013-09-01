require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_fields'
require_relative '../../../lib/import/import_client'
require_relative '../../../lib/import/import_property'
require_relative '../../../lib/import/import_billing_profile'

module DB

  describe 'Patch' do

    def clients_directory
      'spec/fixtures/import_data/clients'
    end

    it 'if no merge file nothing merged' do
      ImportClient.import Import.csv_table('clients', headers: ImportFields.client, location: clients_directory)
      expect(Client.first.address.district).to be_blank
    end

    it 'if import file row id does not match patch row id - nothing happens' do
      ImportClient.import   \
      Import.csv_table('clients', headers: ImportFields.client, location: clients_directory), \
      Patch.import(Client, Import.csv_table('clients_no_row_matches', headers: ImportFields.client, location: 'spec/fixtures/import_data/patch'))
      expect(Client.first.address.district).to be_blank
    end

    it 'if import file row id, matches patch row id - the models attributes are changed' do
      ImportClient.import   \
      Import.csv_table('clients', headers: ImportFields.client, location: clients_directory), \
      Patch.import(Client, Import.csv_table('clients_row_match', headers: ImportFields.client, location: 'spec/fixtures/import_data/patch'))
      expect(Client.first.address.district).to eq 'Example District'
    end

    it 'if entities do not match puts error message' do
      $stdout.should_receive(:puts).with(/Cannot match/)
      ImportClient.import   \
      Import.csv_table('clients', headers: ImportFields.client, location: clients_directory), \
      Patch.import(Client, Import.csv_table('clients_row_match_name_changed', headers: ImportFields.client, location: 'spec/fixtures/import_data/patch'))
    end

    context 'Property' do
      it 'works on property' do
        ImportProperty.import   \
        Import.csv_table('properties', headers: ImportFields.property, drop_rows: 34, location: 'spec/fixtures/import_data/properties'), \
        Patch.import(Property, Import.csv_table('properties_patch', headers: ImportFields.property, location: 'spec/fixtures/import_data/patch'))
        expect(Property.first.address.district).to eq 'Example District'
      end
    end
    context 'BillingProfile' do
      it 'works on BillingProfile' do
        property_factory human_id: 122
        ImportBillingProfile.import   \
        Import.csv_table('address2', headers: ImportFields.billing_profile, location: 'spec/fixtures/import_data/billing_profiles') , \
        Patch.import(BillingProfile, Import.csv_table('address2_patch', headers: ImportFields.billing_profile, location: 'spec/fixtures/import_data/patch'))
        expect(Property.first.billing_profile.address.district).to eq 'Example District Changed'
      end
    end
  end
end