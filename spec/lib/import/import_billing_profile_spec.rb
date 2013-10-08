require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_fields'
require_relative '../../../lib/import/import_billing_profile'

module DB

  describe ImportBillingProfile do
    let!(:property) do
      property_create! human_id: 122
    end

    it 'One row' do
      expect(BillingProfile.first.use_profile).to be_false
      ImportBillingProfile.import billing_csv
      expect(BillingProfile.first.use_profile).to be_true
    end

    it 'One row, 2 Entities' do
      expect { ImportBillingProfile.import billing_csv }.to \
        change(Entity, :count).by 2
    end

    it 'billing profiles have already been created when property created' do
      expect { ImportBillingProfile.import billing_csv }.to_not \
        change(BillingProfile, :count)
    end

    it 'Not double import' do
      expect { ImportBillingProfile.import billing_csv }.to \
        change(Entity, :count).by 2
      expect { ImportBillingProfile.import billing_csv }.to_not \
        change(Entity, :count)
    end

    context 'entities' do
      it 'adds one entity when second entity blank' do
        expect { ImportBillingProfile.import billing_with_1_entity_csv }.to \
          change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        ImportBillingProfile.import billing_csv
        expect(BillingProfile.first.entities[0].created_at).to be \
          < BillingProfile.first.entities[1].created_at
      end

      context 'multiple imports' do

        it 'updated changed entities' do
          ImportBillingProfile.import billing_csv
          ImportBillingProfile.import billing_updated_csv
          expect(BillingProfile.first.entities[0].name).to eq 'Changed'
          expect(BillingProfile.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          ImportBillingProfile.import billing_csv
          expect { ImportBillingProfile.import billing_with_1_entity_csv }.to \
            change(Entity, :count).by(-1)
        end
      end
    end

    def billing_csv
      Import.file_to_arrays('address2',
                            headers: ImportFields.billing_profile,
                            location: billing_profile_dir)
    end

    def billing_updated_csv
      Import.file_to_arrays 'address2_updated',
                            headers: ImportFields.billing_profile,
                            location: billing_profile_dir
    end

    def billing_with_1_entity_csv
      Import.file_to_arrays 'address2_one_entity',
                            headers: ImportFields.billing_profile,
                            location: billing_profile_dir
    end

    def billing_profile_dir
      'spec/fixtures/import_data/billing_profiles'
    end
  end
end
