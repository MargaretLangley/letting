require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_fields'
require_relative '../../../lib/import/import_charge'

module DB
  describe ImportCharge do
    it 'One row' do
      property_create!
      expect { ImportCharge.import charge_csv }.to change(Charge, :count).by 1
    end

    it 'fails if property does not exist' do
      $stdout.should_receive(:puts).with(/human_id: 2002 - Not found/)
      expect { ImportCharge.import charge_csv  }.to \
      raise_error ActiveRecord::RecordNotFound
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
      Import.csv_table('acc_info',
                       headers: ImportFields.charge,
                       location: 'spec/fixtures/import_data/charges')
    end

    def charge_updated_csv
      Import.csv_table('acc_info_updated',
                       headers: ImportFields.charge,
                       location: 'spec/fixtures/import_data/charges')
    end

    def charge_monthly_csv
      Import.csv_table('acc_info_monthly',
                       headers: ImportFields.charge,
                       location: 'spec/fixtures/import_data/charges')
    end

  end
end

