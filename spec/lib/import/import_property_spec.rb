require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_property'

module DB

  describe ImportProperty, :import do

    client = nil
    before :each do
      client = client_create! human_ref: 11
    end

    def row
      %q[122, 2013-02-26 12:35:00, Mr, A N, Example, Mrs, A N, Other,] +
      %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ] +
      %q[11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0]
    end

    it 'One row' do
      expect { import_property row }.to change(Property, :count).by 1
    end

    it 'Client set to table id' do
      import_property row
      expect(Property.first.client_id).to eq client.id
    end

    it 'One row, 2 Entities' do
      expect { import_property row }.to change(Entity, :count).by 2
    end

    it 'Not double import' do
      import_property row
      expect { import_property row }.to_not change(Property, :count)
    end

    it 'Not double import Entity' do
      import_property row
      expect { import_property row }.to_not change(Entity, :count)
    end

    context 'filter' do
      it 'allows within range' do
        expect { import_property row, range: 122..122 }.to change(Property, :count).by 1
      end

      it 'filters if out of range' do
        expect { import_property row, range: 120..121 }.to change(Property, :count).by 0
      end
    end

    context 'use profile' do

      it 'new record to false' do
        import_property row
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
        import_property row
        property = Property.first
        property.prepare_for_form
        property.billing_profile.use_profile = true
        property.billing_profile.address.attributes = oval_address_attributes
        property.billing_profile.entities[0].attributes =
          oval_person_entity_attributes
        property.save!
        import_property row
        expect(Property.first.billing_profile.use_profile).to be_true
      end
    end

    context 'entities' do

      def entity_row
        %q[122, 2013-02-26 12:35:00, Mr, A N, Example, , , ,] +
        %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ] +
        %q[11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0]
      end

      it 'adds one entity when second entity blank' do
        expect { import_property entity_row }.to change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        import_property row
        expect(Property.first.entities[0].created_at).to be < \
          Property.first.entities[1].created_at
      end

      context 'multiple imports' do

        def updated_row
          %q[122, 2013-02-26 12:35:00, Mrs, H V, Changed, Mrs, A N, Other,] +
          %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ] +
          %q[11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0]
        end

        it 'updated changed entities' do
          import_property row
          import_property updated_row
          expect(Property.first.entities[0].name).to eq 'Changed'
          expect(Property.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          import_property row
          expect { import_property entity_row }.to \
            change(Entity, :count).by(-1)
        end
      end
    end

    def import_property row, args = {}
      ImportProperty.import parse(row), args
    end

    def parse row_string
      CSV.parse( row_string,
                 { headers: FileHeader.property,
                   header_converters: :symbol,
                   converters: lambda { |f| f ? f.strip : nil } }
               )
    end

  end
end
