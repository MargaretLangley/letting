require 'rails_helper'

describe RepeatDate, :ledgers, :range do
  describe 'create' do
    describe 'with date' do
      it 'has expected day' do
        day_month = RepeatDate.new date: Date.new(2014, 2, 1)
        expect(day_month.day).to eq 1
      end

      it 'has expected month' do
        day_month = RepeatDate.new date: Date.new(2014, 2, 1)
        expect(day_month.month).to eq 2
      end

      it 'has expected year' do
        day_month = RepeatDate.new date: Date.new(2014, 2, 1)
        expect(day_month.year).to eq 2014
      end
    end

    describe 'with day month' do
      it 'has expected day' do
        day_month = RepeatDate.new year: 2014, month: 2, day: 1
        expect(day_month.day).to eq 1
      end

      it 'has expected month' do
        day_month = RepeatDate.new year: 2014, month: 2, day: 1
        expect(day_month.month).to eq 2
      end

      it 'has expected year' do
        day_month = RepeatDate.new year: 2014, month: 2, day: 1
        expect(day_month.year).to eq 2014
      end

      describe 'defaults' do
        it 'has defaulted to today' do
          day_month = RepeatDate.new
          expect(day_month.date).to eq Date.current
        end
      end
    end
  end

  describe 'method modifiers' do
    it '#yesterday - subtracts 1 day' do
      day_month = RepeatDate.new day: 2, month: 2
      expect(day_month.yesterday.day).to eq 1
    end

    it '#yesterday - subtracts 1 day and does not change' do
      day_month = RepeatDate.new day: 2, month: 2
      expect(day_month.yesterday.day).to eq 1
    end

    it '#tomorrow - adds 1 day' do
      day_month = RepeatDate.new day: 1, month: 2
      expect(day_month.tomorrow.day).to eq 2
    end

    it '#last_year - subtracts 1 year' do
      day_month = RepeatDate.new day: 1, month: 2
      expect(day_month.last_year.year).to eq 2013
    end

    it '#next_year - adds 1 year' do
      day_month = RepeatDate.new day: 1, month: 2
      expect(day_month.next_year.year).to eq 2015
    end
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      a = RepeatDate.new month: 1, day: 1
      b = RepeatDate.new month: 1, day: 1
      expect(a <=> b).to eq(0)
    end

    it 'returns 1 when a > b' do
      a = RepeatDate.new month: 1, day: 2
      b = RepeatDate.new month: 1, day: 1
      expect(a <=> b).to eq(1)
    end

    it 'returns -1 when a < b' do
      a = RepeatDate.new month: 1, day: 1
      b = RepeatDate.new month: 1, day: 2
      expect(a <=> b).to eq(-1)
    end

    it 'years do not affect comparison' do
      a = RepeatDate.new month: 1, day: 1, year: 2000
      b = RepeatDate.new month: 1, day: 1, year: 3000
      expect(a <=> b).to eq(0)
    end

    it 'returns nil when not comparable' do
      expect(RepeatDate.new <=> 37).to be_nil
    end
  end

  describe '#date' do
    it 'returns date' do
      expect(RepeatDate.new(date: Date.new(2014, 2, 1)).date)
        .to eq Date.new(2014, 2, 1)
    end
  end
end
