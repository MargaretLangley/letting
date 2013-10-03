require 'spec_helper'
require_relative '../../../lib/import/charge_values'

module DB
  describe ChargeValues do
    context 'Converts from code' do
      it 'returns a ChargeValues' do
        charge_value = ChargeValues.from_code 'GGR'
        expect(charge_value.charge_code).to eq 'Garage Ground Rent'
      end

      it 'returns a max number of dates per year' do
        charge_value = ChargeValues.from_code 'GGR'
        expect(charge_value.max_dates_per_year).to eq 4
      end

      context 'has maximum row to import' do
        it 'keeps importing below max' do
          charge_value = ChargeValues.from_code 'GGR'
          expect(charge_value.all_date_pairs_imported? 3).to be_false
        end
        it 'stops importing at the max' do
          charge_value = ChargeValues.from_code 'GGR'
          expect(charge_value.all_date_pairs_imported? 4).to be_true
        end
      end
    end
  end
end
