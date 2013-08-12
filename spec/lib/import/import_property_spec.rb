require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_property'

module DB

  describe 'ImportProperty' do

    it "One row" do
      expect{ ImportProperty.import Import.csv_table('properties', location:'spec/fixtures/import_data/properties') }.to \
        change(Property, :count).by 1
    end

    it "One row, 2 Entities" do
      expect{ ImportProperty.import Import.csv_table('properties', location:'spec/fixtures/import_data/properties') }.to \
        change(Entity, :count).by 2
    end

    it "Not double import" do
      expect{ ImportProperty.import Import.csv_table('properties', location:'spec/fixtures/import_data/properties') }.to \
        change(Property, :count).by 1
      expect{ ImportProperty.import Import.csv_table('properties', location:'spec/fixtures/import_data/properties') }.to \
        change(Property, :count).by 0
    end

    it "Not double import" do
      expect{ ImportProperty.import Import.csv_table('properties', location:'spec/fixtures/import_data/properties') }.to \
        change(Entity, :count).by 2
      expect{ ImportProperty.import Import.csv_table('properties', location:'spec/fixtures/import_data/properties') }.to \
        change(Entity, :count).by 0
    end

    context 'entities' do
      it 'adds one entity when second entity blank' do
        expect{ ImportProperty.import Import.csv_table 'properties_one_entity', location:'spec/fixtures/import_data/properties' }.to \
          change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        ImportProperty.import Import.csv_table('properties', location:'spec/fixtures/import_data/properties')
        expect(Property.first.entities[0].created_at).to be < Property.first.entities[1].created_at
      end

      context 'multiple imports' do

        it 'updated changed entities' do
          ImportProperty.import Import.csv_table 'properties', location:'spec/fixtures/import_data/properties'
          ImportProperty.import Import.csv_table 'properties_updated', location:'spec/fixtures/import_data/properties'
          expect(Property.first.entities[0].name).to eq 'Changed'
          expect(Property.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          ImportProperty.import Import.csv_table 'properties', location:'spec/fixtures/import_data/properties'
          expect{ ImportProperty.import Import.csv_table 'properties_one_entity', location:'spec/fixtures/import_data/properties' }.to \
            change(Entity, :count).by -1
        end
      end
    end

    context 'Billing information' do
      it 'imports billing information' do
        pending 'NEED TO IMPLEMENT ASAP'
      end
    end
  end
end
