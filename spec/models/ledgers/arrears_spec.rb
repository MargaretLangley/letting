require 'rails_helper'

# rubocop: disable Metrics/LineLength

describe Arrears, :ledgers, :range do

  it 'initializes with repeat dates' do
    repeat = Arrears.new repeat_dates: [RepeatDate.new(month: 5, day: 4)]
    expect(repeat.periods.length).to eq 1
  end

  describe '#duration returns period bounding date' do
    context 'two periods' do
      it 'returns expected period' do
        repeat = Arrears.new repeat_dates: [RepeatDate.new(year: 2025, month: 3, day: 25),
                                            RepeatDate.new(year: 2025, month: 9, day: 30)]
        expect(repeat.duration(within: Date.new(2025, 9, 30)))
          .to eq Date.new(2025, 3, 26)..Date.new(2025, 9, 30)
      end
    end

    it 'errors if date not found in any period' do
      repeat = Arrears.new repeat_dates: [RepeatDate.new(month: 3, day: 25),
                                          RepeatDate.new(month: 9, day: 30)]
      expect(repeat.duration within: Date.new(2014, 9, 29))
        .to be :missing_due_on
    end
  end

  describe '#periods' do
    it 'calculates periods for one repeated date' do
      repeat = Arrears.new repeat_dates: [RepeatDate.new(year: 2021, month: 3, day: 8)]
      expect(repeat.periods).to eq [[RepeatDate.new(year: 2020, month: 3, day: 9), RepeatDate.new(year: 2021, month: 3, day: 8)]]
    end

    it 'calculates periods for two repeated date' do
      repeat = Arrears.new repeat_dates: [RepeatDate.new(year: 2025, month: 3, day: 25),
                                          RepeatDate.new(year: 2025, month: 9, day: 29)]
      expect(repeat.periods)
        .to eq [[RepeatDate.new(year: 2024, month: 9, day: 30), RepeatDate.new(year: 2025, month: 3, day: 25)],
                [RepeatDate.new(year: 2025, month: 3, day: 26), RepeatDate.new(year: 2025, month: 9, day: 29)]]
    end
  end
end
