require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_charge'

module DB
  describe ImportCharge do
    it 'One row' do
      property_create!
      expect { ImportCharge.import charge_csv }.to change(Charge, :count).by 1
    end

    it 'fails if property does not exist' do
      expect { ImportCharge.import charge_csv }.to \
      raise_error ActiveRecord::RecordNotFound,
                  'Property human_id: 2002 - Not found'
    end

    it 'One row, 2 DueOns' do
      property_create!
      expect { ImportCharge.import charge_csv }.to change(DueOn, :count).by 2
    end

    it 'One monthly row, 12 DueOns' do
      property_create!
      expect { ImportCharge.import charge_monthly_csv }.to \
        change(DueOn, :count).by 12
    end

    it 'Not double import' do
      property_create!
      ImportCharge.import charge_csv
      expect { ImportCharge.import charge_csv }.to_not change(Charge, :count)
    end

    context 'multiple imports' do
      it 'updated changed charge' do
        property_create!
        ImportCharge.import charge_csv
        ImportCharge.import charge_updated_csv
        charge = Charge.first
        expect(charge.amount).to eq 30.5 #
        expect(charge.due_ons[0].day).to eq 24 # same
        expect(charge.due_ons[1].day).to eq 26 # imp one!
      end
    end

    def charge_csv
      FileImport.to_a('acc_info',
                      headers: FileHeader.charge,
                      location: 'spec/fixtures/import_data/charges')
    end

    def charge_updated_csv
      FileImport.to_a('acc_info_updated',
                      headers: FileHeader.charge,
                      location: 'spec/fixtures/import_data/charges')
    end

    def charge_monthly_csv
      FileImport.to_a('acc_info_monthly',
                      headers: FileHeader.charge,
                      location: 'spec/fixtures/import_data/charges')
    end

  end
end
