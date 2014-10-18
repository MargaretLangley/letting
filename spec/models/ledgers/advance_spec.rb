require 'rails_helper'

# rubocop: disable Metrics/LineLength

describe Advance, :ledgers, :range do

  it 'initializes with repeat dates' do
    repeat = Advance.new repeat_dates: [RepeatDate.new(month: 5, day: 4)]
    expect(repeat.periods.length).to eq 1
  end

  describe '#duration returns period bounding date' do
    context 'one period' do
      it 'returns expected period' do
        repeat = Advance.new repeat_dates: [RepeatDate.new(month: 9, day: 3)]
        expect(repeat.duration(within: Date.new(2014, 9, 3)))
          .to eq Date.new(2014, 9, 3)..Date.new(2015, 9, 2)
      end

      it 'returns expect period through a leap day' do
        repeat =
        Advance.new repeat_dates: [RepeatDate.new(year: 2003, month: 2, day: 20)]
        expect(repeat.duration(within: Date.new(2000, 2, 20)))
          .to eq Date.new(2000, 2, 20)..Date.new(2001, 2, 19)
      end
    end

    context 'two periods' do
      it 'returns expected period' do
        repeat = Advance.new repeat_dates: [RepeatDate.new(month: 3, day: 5),
                                            RepeatDate.new(month: 9, day: 3)]
        expect(repeat.duration(within: Date.new(2014, 9, 3)))
          .to eq Date.new(2014, 9, 3)..Date.new(2015, 3, 4)
      end
    end

    it 'errors if date not found in any period' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(month: 9, day: 3)]
      expect(repeat.duration within: Date.new(2014, 9, 4))
        .to be :missing_due_on
    end
  end

  describe '#periods' do
    it 'calculates periods for one repeated date' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(month: 3, day: 8)]
      expect(repeat.periods).to eq [[RepeatDate.new(month: 3, day: 8), RepeatDate.new(month: 3, day: 7)]]
    end

    it 'calculates periods for two repeated date' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2014, month: 2, day: 4),
                                          RepeatDate.new(year: 2014, month: 6, day: 8)]
      expect(repeat.periods).to eq [[RepeatDate.new(month: 2, day: 4), RepeatDate.new(month: 6, day: 7)],
                                    [RepeatDate.new(month: 6, day: 8), RepeatDate.new(month: 2, day: 3)]]
    end
  end
end
