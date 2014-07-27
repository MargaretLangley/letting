require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounting_row'
require_relative '../../..//lib/import/errors.rb'

####
#
# accounting_row_spec.rb
#
# unit testing for AccoutingRow
#
####
#
module DB
  describe AccountingRow do

    let(:accounting) { (Class.new { include AccountingRow }).new }

    describe '#account_id' do
      it 'returns valid' do
        property = property_create! human_ref: 89
        expect(accounting.account(human_ref: 89).id).to eq property.account.id
      end
      it 'errors invalid' do
        expect { accounting.account.id }.to raise_error PropertyRefUnknown
      end
    end

    describe '#charge_id' do
      it 'returns valid charge_id' do
        property = property_create!
        property.account.charges << charge_new(charge_type: 'Rent')
        expect(accounting.charge(account: property.account,
                                 charge_type: 'Rent'))
          .to eq property.account.charges.first
      end
      it 'errors if charge unknown' do
        property = property_create!
        expect do accounting.charge(account: property.account,
                                    charge_type: 'unknown')
        end.to raise_error ChargeUnknown
      end
    end

    describe '#charge_code_to_s' do
      it 'returns valid' do
        property_create! human_ref: 89
        expect(accounting.charge_code_to_s(charge_code: 'Ins', human_ref: 89))
          .to eq 'Insurance'
      end

      it 'errors invalid code' do
        property_create! human_ref: 89
        expect do accounting.charge_code_to_s(charge_code: 'UkwDDn',
                                              human_ref: 89)
        end.to raise_error ChargeCodeUnknown
      end
    end
  end
end
