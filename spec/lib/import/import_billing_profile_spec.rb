require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_billing_profile'

module DB

  describe 'ImportBillingProfile' do
    def headers
      %w{human_id  title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
    end

    let!(:property) do
      property_factory human_id: 122
    end

    it "One row" do
      expect(BillingProfile.first.use_profile).to be_false
      ImportBillingProfile.import Import.csv_table('address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile')
      expect(BillingProfile.first.use_profile).to be_true
    end

    it "One row, 2 Entities" do
      expect{ ImportBillingProfile.import Import.csv_table('address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile') }.to \
        change(Entity, :count).by 2
    end

    it "billing profiles have already been created when property created" do
      expect{ ImportBillingProfile.import Import.csv_table('address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile') }.to \
        change(BillingProfile, :count).by 0
    end

    it "Not double import" do
      expect{ ImportBillingProfile.import Import.csv_table('address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile') }.to \
        change(Entity, :count).by 2
      expect{ ImportBillingProfile.import Import.csv_table('address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile') }.to \
        change(Entity, :count).by 0
    end


    context 'entities' do
      it 'adds one entity when second entity blank' do
        expect{ ImportBillingProfile.import Import.csv_table 'address2_one_entity',  headers: headers, location:'spec/fixtures/import_data/billing_profile' }.to \
          change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        ImportBillingProfile.import Import.csv_table('address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile')
        expect(BillingProfile.first.entities[0].created_at).to be < BillingProfile.first.entities[1].created_at
      end

      context 'multiple imports' do

        it 'updated changed entities' do
          ImportBillingProfile.import Import.csv_table 'address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile'
          ImportBillingProfile.import Import.csv_table 'address2_updated',  headers: headers, location:'spec/fixtures/import_data/billing_profile'
          expect(BillingProfile.first.entities[0].name).to eq 'Changed'
          expect(BillingProfile.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          ImportBillingProfile.import Import.csv_table 'address2',  headers: headers, location:'spec/fixtures/import_data/billing_profile'
          expect{ ImportBillingProfile.import Import.csv_table 'address2_one_entity',  headers: headers, location:'spec/fixtures/import_data/billing_profile' }.to \
            change(Entity, :count).by -1
        end
      end
    end
  end
end
