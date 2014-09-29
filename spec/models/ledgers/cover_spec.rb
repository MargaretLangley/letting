require 'rails_helper'

describe Cover, :ledgers, :range do
  describe '.leap_day?' do
    context 'first date' do
      it 'recognises when it covers a leap year' do
        leap_day_range = Date.new(2020, 2, 1)..Date.new(2021, 4, 1)
        expect(Cover.leap_day?(range: leap_day_range)).to be true
      end

      it 'recognises when it does not cover a leap year' do
        leap_day_range = Date.new(2020, 1, 1)..Date.new(2020, 2, 28)
        expect(Cover.leap_day?(range: leap_day_range)).to be false
      end
    end
    context 'end date' do
      it 'recognises when it covers a leap year' do
        leap_day_range = Date.new(2019, 2, 1)..Date.new(2020, 3, 1)
        expect(Cover.leap_day?(range: leap_day_range)).to be true
      end

      it 'recognises when it does not cover a leap year' do
        leap_day_range = Date.new(2019, 1, 1)..Date.new(2020, 2, 28)
        expect(Cover.leap_day?(range: leap_day_range)).to be false
      end
    end
  end
end
