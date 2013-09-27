require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_fields'
require_relative '../../../lib/import/import_property'

module DB

  describe ImportProperty do

    context 'error state' do
      it 'throws an error if client foreign key not found' do
        expect{ ImportProperty.import Import.csv_table('properties',  \
        headers: ImportFields.property, drop_rows: 34, location: properties_directory) }.to \
        raise_error NameError
      end
    end

    context 'Normal state' do
      client = nil
      before :each do
        client = client_create! human_id: 11
      end

      def properties_directory
        'spec/fixtures/import_data/properties'
      end

      it "One row" do
        expect{ ImportProperty.import Import.csv_table('properties',  \
          headers: ImportFields.property, drop_rows: 34, location: properties_directory) }.to \
          change(Property, :count).by 1
      end

      it "Client set to table id" do
        expect{ ImportProperty.import Import.csv_table('properties',  \
          headers: ImportFields.property, drop_rows: 34, location: properties_directory) }.to \
          change(Property, :count).by 1
        expect(Property.first.client_id).to eq client.id
      end

      it "One row, 2 Entities" do
        expect{ ImportProperty.import Import.csv_table('properties', \
          headers: ImportFields.property, drop_rows: 34, location: properties_directory) }.to \
          change(Entity, :count).by 2
      end

      it "Not double import" do
        expect{ ImportProperty.import Import.csv_table('properties',  \
          headers: ImportFields.property, drop_rows: 34, location: properties_directory) }.to \
          change(Property, :count).by 1
        expect{ ImportProperty.import Import.csv_table('properties', headers: ImportFields.property, \
          drop_rows: 34, location: properties_directory) }.to \
          change(Property, :count).by 0
      end

      it "Not double import" do
        expect{ ImportProperty.import Import.csv_table('properties', headers: ImportFields.property, \
          drop_rows: 34, location: properties_directory) }.to \
          change(Entity, :count).by 2
        expect{ ImportProperty.import Import.csv_table('properties', headers: ImportFields.property, \
          drop_rows: 34, location: properties_directory) }.to \
          change(Entity, :count).by 0
      end

      context 'use profile' do

        it "new record to false" do
          ImportProperty.import Import.csv_table('properties', headers: ImportFields.property, \
            drop_rows: 34, location: properties_directory)
          expect(Property.first.billing_profile.use_profile).to be_false
        end

          # Nice setup!
          # I'm worried that I might start overwriting use_profile
          # The profile addresses were kept in different tables on the
          # original system. This means importing it separately after the
          # property import and know I won't change use_profile accidently.
          # Import the record. Save a profile onto it. Import again and see that
          # Profile still true.
        it 'does not alter use profile' do
          ImportProperty.import Import.csv_table('properties', headers: ImportFields.property, \
            drop_rows: 34, location: properties_directory)
          property = Property.first
          property.prepare_for_form
          property.billing_profile.use_profile = true
          property.billing_profile.address.attributes = oval_address_attributes
          property.billing_profile.entities[0].attributes = oval_person_entity_attributes
          property.save!
          ImportProperty.import Import.csv_table('properties', headers: ImportFields.property, \
            drop_rows: 34, location: properties_directory)
          expect(Property.first.billing_profile.use_profile).to be_true
        end
      end

      context 'entities' do
        it 'adds one entity when second entity blank' do
          expect{ ImportProperty.import Import.csv_table 'properties_one_entity',  \
            drop_rows: 34, headers: ImportFields.property, location: properties_directory }.to \
            change(Entity, :count).by 1
        end

        it 'ordered by creation' do
          ImportProperty.import Import.csv_table('properties',  headers: ImportFields.property, \
            drop_rows: 34, location: properties_directory)
          expect(Property.first.entities[0].created_at).to be < Property.first.entities[1].created_at
        end

        context 'multiple imports' do

          it 'updated changed entities' do
            ImportProperty.import Import.csv_table 'properties',  \
              drop_rows: 34, headers: ImportFields.property, location: properties_directory
            ImportProperty.import Import.csv_table 'properties_updated',  \
              drop_rows: 34, headers: ImportFields.property, location: properties_directory
            expect(Property.first.entities[0].name).to eq 'Changed'
            expect(Property.first.entities[1].name).to eq 'Other'
          end

          it 'removes deleted second entities' do
            ImportProperty.import Import.csv_table 'properties', headers: ImportFields.property, \
              drop_rows: 34, location: properties_directory
            expect{ ImportProperty.import Import.csv_table 'properties_one_entity',  \
                drop_rows: 34, headers: ImportFields.property, location: properties_directory }.to \
                change(Entity, :count).by -1
          end
        end
      end
    end
  end
end
