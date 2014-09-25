require 'rails_helper'

describe RepeatRange, :ledgers, :range do
  before { Timecop.travel Date.new(2014, 1, 31) }
  after  { Timecop.return }

  describe 'initializes' do
    # validation?
    # it 'empty' do
    # end

    it 'can use dates' do
      repeat = RepeatRange.new name: 'Advance',
                               billed_on: '2014-06-06',
                               dates: [Date.new(2014, 6, 5)]
      expect(repeat.dates_in_year.length).to eq 1
      expect(repeat.dates_in_year.first.month).to eq 6
    end

    it 'can use repeat dates' do
      repeat = RepeatRange.new \
                 name: 'Advance',
                 billed_on: '2014-06-05',
                 repeat_dates: [RepeatDate.new(year: 2014, month: 6, day: 5)]
      expect(repeat.dates_in_year.length).to eq 1
      expect(repeat.dates_in_year.first.month).to eq 6
    end
  end

  describe '#billing_period2' do
    before { Timecop.travel Date.new(2014, 1, 31) }
    after  { Timecop.return }
    # currently returning the 'on_date' which initialized
    # the Repeat range - but will eventually be the range
    it 'finds advanced range' do
      repeat = RepeatRange.new name: 'Advance',
                               billed_on: Date.new(2014, 6, 6),
                               dates: [Date.new(2014, 6, 6)]
      expect(repeat.billing_period)
        .to eq Date.new(2014, 6, 6)..Date.new(2015, 6, 5)
    end

    it 'finds arrears range' do
      repeat = RepeatRange.new name: 'Arrears',
                               billed_on: Date.new(2014, 6, 6),
                               dates: [Date.new(2014, 6, 6)]
      expect(repeat.billing_period)
        .to eq Date.new(2013, 6, 7)..Date.new(2014, 6, 6)
    end

    it 'errors when due on not found' do
      repeat = RepeatRange.new name: 'Advance',
                               billed_on: Date.new(2014, 12, 12),
                               dates: [Date.new(2014, 6, 6)]
      expect(repeat.billing_period).to eq :missing_due_on
    end
  end
end
