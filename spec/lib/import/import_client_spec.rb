require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_client'

module DB

  describe 'Import' do

    it "One row" do
      expect{ ImportClient.import Import.csv_table('clients','spec/import_data') }.to \
        change(Client, :count).by 1
    end

    it "One row, 2 Entities" do
      expect{ ImportClient.import Import.csv_table('clients','spec/import_data') }.to \
        change(Entity, :count).by 2
    end

    it "Not double import" do
      expect{ ImportClient.import Import.csv_table('clients','spec/import_data') }.to \
        change(Client, :count).by 1
      expect{ ImportClient.import Import.csv_table('clients','spec/import_data') }.to \
        change(Client, :count).by 0
    end

    it "Not double import" do
      expect{ ImportClient.import Import.csv_table('clients','spec/import_data') }.to \
        change(Entity, :count).by 2
      expect{ ImportClient.import Import.csv_table('clients','spec/import_data') }.to \
        change(Entity, :count).by 0
    end

    context 'entities' do
      it 'adds one entity when second entity blank' do
        expect{ ImportClient.import Import.csv_table 'clients_one_entity','spec/import_data' }.to \
          change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        ImportClient.import Import.csv_table('clients','spec/import_data')
        expect(Client.first.entities[0].created_at).to be < Client.first.entities[1].created_at
      end

      context 'muliple imports' do

        it 'updated changed entities' do
          ImportClient.import Import.csv_table 'clients','spec/import_data'
          ImportClient.import Import.csv_table 'client_updated','spec/import_data'
          expect(Client.first.entities[0].name).to eq 'Changed'
          expect(Client.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          ImportClient.import Import.csv_table 'clients','spec/import_data'
          expect{ ImportClient.import Import.csv_table 'clients_one_entity','spec/import_data' }.to \
            change(Entity, :count).by -1
        end
      end
    end
  end
end
