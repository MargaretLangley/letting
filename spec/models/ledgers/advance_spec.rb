require 'rails_helper'

describe Advance, :ledgers, :range do

  describe 'initializes' do
    # it 'empty' do
    #   expect(Advance.new.periods.length).to eq 0
    # end

    it 'can use repeat dates' do
      repeat = Advance.new(
                 repeat_dates: [RepeatDate.new(year: 2014, month: 5, day: 4)])
      expect(repeat.periods.length).to eq 1
    end
  end

  describe '#billing_period' do
    it 'matches on date' do
      repeat = Advance.new(
                 repeat_dates: [RepeatDate.new(year: 2014, month: 3, day: 25),
                                RepeatDate.new(year: 2014, month: 9, day: 30)])
      expect(repeat.billing_period(billed_date: Date.new(2014, 9, 30)))
        .to eq Date.new(2014, 9, 30)..Date.new(2015, 3, 24)
    end

    it 'does not match when identifying an unknown' do
      repeat = Advance.new(
                 repeat_dates: [RepeatDate.new(year: 2014, month: 3, day: 25),
                                RepeatDate.new(year: 2014, month: 9, day: 30)])
      expect(repeat.billing_period billed_date: Date.new(2014, 9, 29))
        .to be :missing_due_on
    end
  end

  describe 'advance' do
    it 'two dates' do
      repeat = Advance.new(
                 repeat_dates: [RepeatDate.new(year: 2014, month: 3, day: 25),
                                RepeatDate.new(year: 2014, month: 9, day: 30)])
      expect(repeat.periods)
        .to eq [[RepeatDate.new(year: 2014, month: 3, day: 25),
                 RepeatDate.new(year: 2014, month: 9, day: 29)],
                [RepeatDate.new(year: 2014, month: 9, day: 30),
                 RepeatDate.new(year: 2015, month: 3, day: 24)]]
    end
  end
end
