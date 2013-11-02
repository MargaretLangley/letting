require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_billing_profile'

module DB

  describe ImportBillingProfile, :import do
    let!(:property) do
      property_create! human_ref: 122
    end

    def row
      %q[122, Mr, B P, Example, Mrs, A N, Other,] +
      %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ]
    end

    it 'One row' do
      expect(BillingProfile.first.use_profile).to be_false
      expect { import_billing row }.to_not change(BillingProfile, :count)
      expect(BillingProfile.first.use_profile).to be_true
    end

    context 'filter' do
      it 'allows within range' do
        import_billing row, range: 122..122
        expect(BillingProfile.first.use_profile).to be_true
      end

      it 'filters if out of range' do
        import_billing row, range: 120..121
        expect(BillingProfile.first.use_profile).to be_false
      end
    end

    context 'entities' do

      def row_1_entity
        %q[122, Mr, B P, Example, , , ,] +
        %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ]
      end

      it 'One row, 2 Entities' do
        expect { import_billing row }.to change(Entity, :count).by 2
      end

      it 'adds one entity when second entity blank' do
        expect { import_billing row_1_entity }.to change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        import_billing row
        entities = BillingProfile.first.entities
        expect(entities[0].created_at).to be < entities[1].created_at
      end

      context 'double imports on entities' do

        it 'count stays the same' do
          expect { import_billing row }.to change(Entity, :count).by 2
          expect { import_billing row }.to_not change(Entity, :count)
        end

        def changed_row
          %q[122, Mr, B P, Changed, Mrs, A N, Other,] +
          %q[1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ]
        end

        it 'updates values' do
          import_billing row
          import_billing changed_row
          expect(BillingProfile.first.entities[0].name).to eq 'Changed'
          expect(BillingProfile.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          import_billing row
          expect { import_billing row_1_entity }.to \
            change(Entity, :count).by(-1)
        end
      end
    end

    def import_billing row, args = {}
      ImportBillingProfile.import parse(row), args
    end

    def parse row_string
      CSV.parse( row_string,
                 { headers: FileHeader.billing_profile,
                   header_converters: :symbol,
                   converters: lambda { |f| f ? f.strip : nil } }
               )
    end
  end
end
