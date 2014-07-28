require 'spec_helper'
require_relative '../../../lib/import/charge_code'
# rubocop: disable Style/Documentation

module DB
  describe ChargeCode do
    context 'Converts code' do

      it '#to_string' do
        expect(ChargeCode.to_string 'GGR').to eq 'Garage Ground Rent'
      end

      it '#to_times_per_year' do
        expect(ChargeCode.to_times_per_year 'GGR').to eq 4
      end
    end
  end
end
