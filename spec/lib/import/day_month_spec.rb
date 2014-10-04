require 'rails_helper'
require_relative '../../../lib/import/charges/day_month'
# rubocop: disable Style/Documentation

module DB
  describe DayMonth, :import do
    context 'Converts day and month into object' do
      it 'returns a ChargeValues' do
        daymonth = DayMonth.from_day_month 1, 10
        expect(daymonth.day).to eq 1
        expect(daymonth.month).to eq 10
      end
    end
  end
end
