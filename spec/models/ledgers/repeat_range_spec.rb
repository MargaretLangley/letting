require 'rails_helper'

describe RepeatRange, :ledgers, :range do
  before { Timecop.travel Date.new(2014, 1, 31) }
  after  { Timecop.return }

  describe 'initializes' do
    # validation?
    # it 'empty' do
    # end

    it 'can use dates' do
      repeat = RepeatRange.for name: 'Advance',
                               dates: [Date.new(2014, 6, 5)]
      expect(repeat.periods.length).to eq 1
      expect(repeat.periods.first.first.month).to eq 6
    end

    it 'can use repeat dates' do
      repeat = RepeatRange.for \
                 name: 'Advance',
                 repeat_dates: [RepeatDate.new(year: 2014, month: 6, day: 5)]
      expect(repeat.periods.length).to eq 1
      expect(repeat.periods.first.first.month).to eq 6
    end
  end

  describe '#billing_period2' do
    before { Timecop.travel Date.new(2014, 1, 31) }
    after  { Timecop.return }
    # currently returning the 'on_date' which initialized
    # the Repeat range - but will eventually be the range
    it 'finds advanced range' do
      repeat = RepeatRange.for name: 'Advance',
                               dates: [Date.new(2014, 6, 6)]
      expect(repeat.billing_period billed_date: Date.new(2014, 6, 6))
        .to eq Date.new(2014, 6, 6)..Date.new(2015, 6, 5)
    end

    it 'finds arrears range' do
      repeat = RepeatRange.for name: 'Arrears',
                               dates: [Date.new(2014, 6, 6)]
      expect(repeat.billing_period billed_date: Date.new(2014, 6, 6))
        .to eq Date.new(2013, 6, 7)..Date.new(2014, 6, 6)
    end

    it 'errors when due on not found' do
      repeat = RepeatRange.for name: 'Advance',
                               dates: [Date.new(2014, 6, 6)]
      expect(repeat.billing_period billed_date:  Date.new(2014, 12, 12))
        .to eq :missing_due_on
    end
  end
end
