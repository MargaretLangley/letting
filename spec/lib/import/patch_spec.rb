require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/patch'
require_relative '../../../lib/import/import_client'
require_relative '../../../lib/import/import_property'
require_relative '../../../lib/import/import_billing_profile'

module DB

  describe 'Patch', :import do

    it 'if no merge file nothing merged' do
      ImportClient.import clients_csv
      expect(Client.first.address.district).to be_blank
    end

    it 'if import row_id != patch row id - nothing changes' do
      ImportClient.import clients_csv,
                          patch: Patch.import(Client, clients_no_row_match_csv)
      expect(Client.first.address.district).to be_blank
    end

    it 'if import row id == patch row id - change attributes' do
      ImportClient.import clients_csv,
                          patch: Patch.import(Client, clients_row_match_csv)
      expect(Client.first.address.district).to eq 'Example District'
    end

    it 'if entities do not match puts error message' do
      $stdout.should_receive(:puts).with(/Cannot match/)
      ImportClient.import clients_csv,
                          patch: Patch.import(Client, clients_row_match_name_changed)
    end

    context 'Property' do
      it 'works on property' do
        client_create! human_ref: 11
        ImportProperty.import property_csv,
                              patch: Patch.import(Property, property_patch_csv)
        expect(Property.first.address.district).to eq 'Example District'
      end
    end

    context 'BillingProfile' do
      it 'works on BillingProfile' do
        property_create! human_ref: 122
        ImportBillingProfile.import \
          billing_csv, patch: Patch.import(BillingProfileWithId, billing_patch_csv)
        expect(Property.first.billing_profile.address.district).to \
          eq 'Example District Changed'
      end
    end

    def clients_directory
      'spec/fixtures/import_data/clients'
    end

    def clients_csv
      FileImport.to_a('clients',
                      headers: FileHeader.client,
                      location: clients_directory)
    end

    def clients_no_row_match_csv
      FileImport.to_a('clients_no_row_matches',
                      headers: FileHeader.client,
                      location: 'spec/fixtures/import_data/patch')
    end

    def clients_row_match_csv
      FileImport.to_a('clients_row_match',
                      headers: FileHeader.client,
                      location: 'spec/fixtures/import_data/patch')
    end

    def clients_row_match_name_changed
      FileImport.to_a('clients_row_match_name_changed',
                      headers: FileHeader.client,
                      location: 'spec/fixtures/import_data/patch')
    end

    def property_csv
      FileImport.to_a('properties',
                      headers: FileHeader.property,
                      drop_rows: 34,
                      location: 'spec/fixtures/import_data/properties')
    end

    def property_patch_csv
      FileImport.to_a('properties_patch',
                      headers: FileHeader.property,
                      location: 'spec/fixtures/import_data/patch')
    end

    def billing_csv
      FileImport.to_a('address2',
                      headers: FileHeader.billing_profile,
                      location: billing_profile_dir)
    end

    def billing_profile_dir
      'spec/fixtures/import_data/billing_profiles'
    end

    def billing_patch_csv
      FileImport.to_a('address2_patch',
                      headers: FileHeader.billing_profile,
                      location: 'spec/fixtures/import_data/patch')
    end

  end
end
