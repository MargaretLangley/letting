require 'rails_helper'

describe RepeatDate, :range do
  before { Timecop.travel(Date.new(2014, 3, 25)) }

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
    end
    describe 'with day month' do
      it 'has expected day' do
        day_month = RepeatDate.new day: 1, month: 2
        expect(day_month.day).to eq 1
      end

      it 'has expected month' do
        day_month = RepeatDate.new day: 1, month: 2
        expect(day_month.month).to eq 2
      end

      describe 'defaults' do
        before { Timecop.travel(Date.new(2014, 3, 25)) }

        it 'has expected day' do
          day_month = RepeatDate.new
          expect(day_month.day).to eq 25
        end

        it 'has expected month' do
          day_month = RepeatDate.new
          expect(day_month.month).to eq 3
        end
      end
    end
  end

  describe 'next' do
    it 'returns next year' do
      day_month = RepeatDate.new day: 1, month: 2
      expect(day_month.next_year.year).to eq 2015
    end
  end
end
