require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_client'

module DB
  describe ImportClient, :import do
    it 'One row' do
      expect { ImportClient.import client_csv }.to change(Client, :count).by 1
    end

    it 'One row, 2 Entities' do
      expect { ImportClient.import client_csv }.to change(Entity, :count).by 2
    end

    it 'Not double import' do
      ImportClient.import client_csv
      expect { ImportClient.import client_csv }.to_not change(Client, :count)
    end

    it 'Not double import' do
      expect { ImportClient.import client_csv }.to change(Entity, :count).by 2
      expect { ImportClient.import client_csv }.to_not change(Entity, :count)
    end

    context 'entities' do
      it 'adds one entity when second entity blank' do
        expect { ImportClient.import client_one_entity_csv }
          .to change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        ImportClient.import ImportClient.import client_csv
        expect(Client.first.entities[0].created_at).to be <
          Client.first.entities[1].created_at
      end

      context 'multiple imports' do

        it 'updated changed entities' do
          ImportClient.import client_csv
          ImportClient.import client_updated_csv
          expect(Client.first.entities[0].name).to eq 'Changed'
          expect(Client.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          ImportClient.import client_csv
          expect { ImportClient.import client_one_entity_csv }
            .to change(Entity, :count).by(-1)
        end
      end

      context 'In odd state' do
        it 'concats a company with intials' do
          ImportClient.import client_company_with_intials_csv
          expect(Entity.first.name).to eq 'A D Example Ltd'
        end
      end
    end

    def client_csv
      FileImport.to_a('clients',
                      headers: FileHeader.client,
                      location: 'spec/fixtures/import_data/clients')
    end

    def client_updated_csv
      FileImport.to_a 'clients_updated',
                      headers: FileHeader.client,
                      location: 'spec/fixtures/import_data/clients'
    end

    def client_one_entity_csv
      FileImport.to_a 'clients_one_entity',
                      headers: FileHeader.client,
                      location: 'spec/fixtures/import_data/clients'
    end

    def client_company_with_intials_csv
      FileImport.to_a 'clients_company_with_initials',
                      headers: FileHeader.client,
                      location: 'spec/fixtures/import_data/clients'
    end
  end
end
