require 'rails_helper'

describe Advance, :ledgers, :range do

  describe 'initializes' do
    it 'can use repeat dates' do
      repeat =
        Advance.new repeat_dates: [RepeatDate.new(year: 2014, month: 5, day: 4)]
      expect(repeat.periods.length).to eq 1
    end
  end

  describe '#billing_period' do
    it 'returns expected period for one_date' do
      repeat =
      Advance.new repeat_dates: [RepeatDate.new(year: 2014, month: 9, day: 3)]
      expect(repeat.billing_period(billed_on: Date.new(2014, 9, 3)))
        .to eq Date.new(2014, 9, 3)..Date.new(2015, 9, 2)
    end

    it 'returns expected period for one_date through leap day' do
      repeat =
      Advance.new repeat_dates: [RepeatDate.new(year: 2003, month: 2, day: 20)]
      expect(repeat.billing_period(billed_on: Date.new(2000, 2, 20)))
        .to eq Date.new(2000, 2, 20)..Date.new(2001, 2, 19)
    end

    context 'two dates' do
      it 'returns expected period' do
        repeat =
        Advance.new repeat_dates: [RepeatDate.new(year: 2014, month: 3, day: 5),
                                   RepeatDate.new(year: 2014, month: 9, day: 3)]
        expect(repeat.billing_period(billed_on: Date.new(2014, 9, 3)))
          .to eq Date.new(2014, 9, 3)..Date.new(2015, 3, 4)
      end
    end

    it 'does not match when identifying an unknown' do
      repeat =
        Advance.new repeat_dates: [RepeatDate.new(year: 2014, month: 9, day: 3)]
      expect(repeat.billing_period billed_on: Date.new(2014, 9, 4))
        .to be :missing_due_on
    end
  end

  describe '#period_length' do
    before { Timecop.travel Date.new(2015, 10, 31) }
    before { Timecop.return }
    it 'calculates on date correctly' do
      repeat =
        Advance.new repeat_dates: [RepeatDate.new(year: 2018, month: 3, day: 8)]
      expect(repeat.period_length(period: repeat.periods.first).to_i).to eq 364
    end
  end

  describe '#dates' do
    it 'one date' do
      repeat =
        Advance.new repeat_dates: [RepeatDate.new(year: 2014, month: 3, day: 8)]
      expect(repeat.dates).to eq [[Date.new(2014, 3, 8), Date.new(2015, 3, 7)]]
    end
    it 'two dates' do
      repeat =
        Advance.new repeat_dates: [RepeatDate.new(year: 2014, month: 2, day: 4),
                                   RepeatDate.new(year: 2014, month: 6, day: 8)]
      expect(repeat.dates).to eq [[Date.new(2014, 2, 4), Date.new(2014, 6, 7)],
                                  [Date.new(2014, 6, 8), Date.new(2015, 2, 3)]]
    end
  end
end
