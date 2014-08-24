require 'rails_helper'

describe RepeatRange, :range do

  describe 'initializes' do
    it 'empty' do
      repeat = RepeatRange.new
      expect(repeat.dates_in_year.length).to eq 0
    end

    it 'can use dates' do
      repeat = RepeatRange.new(dates: [Date.new(2014, 3, 1)])
      expect(repeat.dates_in_year.length).to eq 1
      expect(repeat.dates_in_year.first.month).to eq 3
    end

    it 'can use repeat dates' do
      repeat = RepeatRange.new(
                 repeat_dates: [RepeatDate.new(year: 2014, month: 5, day: 4)])
      expect(repeat.dates_in_year.length).to eq 1
      expect(repeat.dates_in_year.first.month).to eq 5
    end
  end

  it 'pushes' do
    repeat = RepeatRange.new
    repeat.push repeat_date: RepeatDate.new(year: 2014, month: 2, day: 1)
    expect(repeat.dates_in_year.length).to eq 1
  end

  describe 'find by' do
    it 'matches on date' do
      repeat = RepeatRange.new
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 3, day: 25)
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 9, day: 30)
      expect(repeat.find Date.new(2014, 9, 30)).to eq repeat.dates_in_year.last
    end

    it 'does not match when identifying an unknown' do
      repeat = RepeatRange.new
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 3, day: 25)
      expect(repeat.find Date.new(2014, 9, 30)).to be_nil
    end
  end

  describe 'advanced' do
    it 'one date' do
      repeat = RepeatRange.new
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 4, day: 1)
      expect(repeat.advance_ranges)
        .to eq [[RepeatDate.new(day: 1, month: 4, year: 2014),
                 RepeatDate.new(day: 31, month: 3, year: 2015)]]
    end

    it 'two dates' do
      repeat = RepeatRange.new
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 3, day: 25)
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 9, day: 29)
      expect(repeat.advance_ranges)
        .to eq [[RepeatDate.new(year: 2014, month: 3, day: 25),
                 RepeatDate.new(year: 2014, month: 9, day: 28)],
                [RepeatDate.new(year: 2014, month: 9, day: 29),
                 RepeatDate.new(year: 2015, month: 3, day: 24)]]
    end
  end

  describe 'arrears' do
    it 'two dates' do
      repeat = RepeatRange.new
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 3, day: 25)
      repeat.push repeat_date: RepeatDate.new(year: 2014, month: 9, day: 29)
      expect(repeat.arrears_ranges)
        .to eq [[RepeatDate.new(year: 2013, month: 9, day: 30),
                 RepeatDate.new(year: 2014, month: 3, day: 25)],
                [RepeatDate.new(year: 2014, month: 3, day: 26),
                 RepeatDate.new(year: 2014, month: 9, day: 29)]]
    end
  end
end
