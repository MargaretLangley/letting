require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_property'

module DB

  describe ImportProperty, :import do

    context 'error state' do
      it 'throws an error if client foreign key not found' do
        expect { property_csv }.to raise_error NameError
      end
    end

    context 'Normal state' do
      client = nil
      before :each do
        client = client_create! human_ref: 11
      end

      it 'One row' do
        expect { ImportProperty.import property_csv }.to \
          change(Property, :count).by 1
      end

      it 'Client set to table id' do
        expect { ImportProperty.import property_csv }.to \
          change(Property, :count).by 1
        expect(Property.first.client_id).to eq client.id
      end

      it 'One row, 2 Entities' do
        expect { ImportProperty.import property_csv }.to \
          change(Entity, :count).by 2
      end

      it 'Not double import' do
        expect { ImportProperty.import property_csv }.to \
          change(Property, :count).by 1
        expect { ImportProperty.import property_csv }.to_not \
          change(Property, :count)
      end

      it 'Not double import' do
        expect { ImportProperty.import property_csv }.to \
          change(Entity, :count).by 2
        expect { ImportProperty.import property_csv }.to_not \
          change(Entity, :count)
      end

      context 'use profile' do

        it 'new record to false' do
          ImportProperty.import property_csv
          expect(Property.first.billing_profile.use_profile).to be_false
        end

          # Nice setup!
          # I'm worried that I might start overwriting use_profile
          # The profile addresses were kept in different tables on the
          # original system. This means importing it separately after the
          # property import and know I won't change use_profile accidently.
          # Import the record. Save a profile onto it. Import again and
          # see that Profile still true.
        it 'does not alter use profile' do
          ImportProperty.import property_csv
          property = Property.first
          property.prepare_for_form
          property.billing_profile.use_profile = true
          property.billing_profile.address.attributes = oval_address_attributes
          property.billing_profile.entities[0].attributes =
            oval_person_entity_attributes
          property.save!
          ImportProperty.import property_csv
          expect(Property.first.billing_profile.use_profile).to be_true
        end
      end

      context 'entities' do
        it 'adds one entity when second entity blank' do
          expect { ImportProperty.import property_1_entity_csv }.to \
            change(Entity, :count).by 1
        end

        it 'ordered by creation' do
          ImportProperty.import property_csv
          expect(Property.first.entities[0].created_at).to be < \
            Property.first.entities[1].created_at
        end

        context 'multiple imports' do

          it 'updated changed entities' do
            ImportProperty.import property_csv
            ImportProperty.import property_updated_csv
            expect(Property.first.entities[0].name).to eq 'Changed'
            expect(Property.first.entities[1].name).to eq 'Other'
          end

          it 'removes deleted second entities' do
            ImportProperty.import property_csv
            expect { ImportProperty.import property_1_entity_csv }.to \
                change(Entity, :count).by(-1)
          end
        end
      end

      def property_csv
        FileImport.to_a('properties',
                        headers: FileHeader.property,
                        drop_rows: 34,
                        location: properties_directory)
      end

      def property_updated_csv
        FileImport.to_a 'properties_updated',
                        drop_rows: 34,
                        headers: FileHeader.property,
                        location: properties_directory
      end

      def property_1_entity_csv
        FileImport.to_a 'properties_one_entity',
                        drop_rows: 34,
                        headers: FileHeader.property,
                        location: properties_directory
      end

      def properties_directory
        'spec/fixtures/import_data/properties'
      end
    end
  end
end
