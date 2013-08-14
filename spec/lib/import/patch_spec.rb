require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_client'
require_relative '../../../lib/import/import_property'

module DB

  describe 'Patch' do

    def clients_directory
      'spec/fixtures/import_data/clients'
    end

    def headers
      %w{human_id  title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
    end

    it 'if no merge file nothing merged' do
      ImportClient.import Import.csv_table('clients', headers: headers, location: clients_directory)
      expect(Client.first.address.district).to be_blank
    end

    it 'if import file row id does not match patch row id - nothing happens' do
      ImportClient.import   \
      Import.csv_table('clients', headers: headers, location: clients_directory), \
      Patch.import(Client, Import.csv_table('clients_no_row_matches', headers: headers, location: 'spec/fixtures/import_data/patch'))
      expect(Client.first.address.district).to be_blank
    end

    it 'if import file row id, matches patch row id - the models attributes are changed' do
      ImportClient.import   \
      Import.csv_table('clients', headers: headers, location: clients_directory), \
      Patch.import(Client, Import.csv_table('clients_row_match', headers: headers, location: 'spec/fixtures/import_data/patch'))
      expect(Client.first.address.district).to eq 'Example District'
    end

    it 'if entities do not match puts error message' do
      $stdout.should_receive(:puts).with(/Cannot match/)
      ImportClient.import   \
      Import.csv_table('clients', headers: headers, location: clients_directory), \
      Patch.import(Client, Import.csv_table('clients_row_match_name_changed', headers: headers, location: 'spec/fixtures/import_data/patch'))
    end

    context 'Property' do
      it 'works on property' do
        property_headers = %w{human_id updated title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
        ImportProperty.import   \
        Import.csv_table('properties', headers: property_headers, drop_rows: 34, location: 'spec/fixtures/import_data/properties'), \
        Patch.import(Property, Import.csv_table('properties_patch', headers: headers, location: 'spec/fixtures/import_data/patch'))
        expect(Property.first.address.district).to eq 'Example District'
      end
    end
  end
end