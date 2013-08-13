require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_client'

module DB

  describe 'Patch' do
    def headers
      %w{human_id  title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
    end

    it 'if no merge file nothing merged' do
      ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients')
      expect(Client.first.address.district).to be_blank
    end

    it 'if import file row id does not match patch row id - nothing happens' do
      patch = Patch.new Import.csv_table('clients_no_row_matches', headers: headers, location: 'spec/fixtures/import_data/patch')
      patch.build_patching_models Client

      ImportClient.import   \
      Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients'), patch
      expect(Client.first.address.district).to be_blank
    end

    it 'if import file row id, matches patch row id - the models attributes are changed' do
      patch = Patch.new Import.csv_table('clients_row_match', headers: headers, location: 'spec/fixtures/import_data/patch')
      patch.build_patching_models Client

      ImportClient.import   \
      Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients'), patch
      expect(Client.first.address.district).to eq 'Example District'
    end

    it 'if entities do not match puts error message' do
       patch = Patch.new Import.csv_table('clients_row_match_name_changed', headers: headers, location: 'spec/fixtures/import_data/patch')
       patch.build_patching_models Client

        $stdout.should_receive(:puts).with(/Cannot match/)
       ImportClient.import   \
       Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients'), patch
    end
  end
end