require 'rails_helper'

# rubocop: disable Style/TrivialAccessors
# rubocop: disable Style/Documentation
# rubocop: disable Lint/UselessComparison

describe DueOn, :ledgers, type: :model do
  it('is valid') { expect(due_on_new).to be_valid }

  describe 'Attribute' do
    describe 'day' do
      it('is required')   { expect(due_on_new day: nil).to_not be_valid }
      it('is numeric')    { expect(due_on_new day: 'ab').to_not be_valid }
      it('is an integer') { expect(due_on_new day: 8.3).to_not be_valid }
      it('is > 0')        { expect(due_on_new day: 0).to_not be_valid }
      it('is < 32')       { expect(due_on_new day: 32).to_not be_valid }
    end

    describe 'month' do
      it('is required')   { expect(due_on_new month: nil).to_not be_valid }
      it('is numeric')    { expect(due_on_new month: 'ab').to_not be_valid }
      it('is an integer') { expect(due_on_new month: 8.3).to_not be_valid }
      it('is > -1')        { expect(due_on_new month: -2).to_not be_valid }
      it('is < 13')       { expect(due_on_new month: 13).to_not be_valid }
    end

    describe 'year' do
      it('is numeric')    { expect(due_on_new year: 'ab').to_not be_valid }
      it('is an integer') { expect(due_on_new year: 8.3).to_not be_valid }
      it('is >= 1990')    { expect(due_on_new year: 1989).to_not be_valid }
      it('is < 2030')     { expect(due_on_new year: 2030).to_not be_valid }
    end
  end

  describe 'methods' do
    describe '#between?' do
      before { Timecop.travel Date.new 2013, 1, 31 }
      after { Timecop.return }

      it 'is true when the range covers due_on' do
        expect(due_on_new(day: 25, month: 3)
          .between? Time.new(2013, 3, 25)..Date.new(2013, 3, 25)).to be true
      end

      it 'is false when range misses due_on' do
        expect(due_on_new(day: 1, month: 1)
          .between? Time.new(2013, 3, 25)..Date.new(2013, 3, 25)).to be false
      end
    end

    describe '#clear_up_form' do
      context 'new' do
        it 'saveable when valid' do
          due_on = due_on_new day: 1, month: nil
          due_on.clear_up_form
          expect(due_on).to_not be_marked_for_destruction
        end

        it 'destroyed when invalid' do
          due_on = due_on_new day: nil, month: nil
          due_on.clear_up_form
          expect(due_on).to be_marked_for_destruction
        end
      end
    end

    describe '#makedate' do
      before { Timecop.travel Date.new 2014, 3, 25 }
      after { Timecop.return }

      it 'before the date it creates a date with this year' do
        expect(due_on_new(day: 25, month: 3).make_date)
          .to eq Date.new(2014, 3, 25)
      end

      it 'after the date it creates a date with next year' do
        expect(due_on_new(day: 23, month: 3).make_date)
          .to eq Date.new(2015, 3, 23)
      end

      it 'uses any set year' do
        expect(due_on_new(day: 23, month: 3, year: 2020).make_date)
        .to eq Date.new(2020, 3, 23)
      end
    end

    # public as it is called by due_ons.empty?
    describe '#empty?' do
      it 'with attributes not empty' do
        expect(due_on_new day: 25, month: 3).to_not be_empty
      end
      it 'without attributes empty' do
        expect(due_on_new day: nil, month: nil).to be_empty
      end
    end

    it 'outputs #to_s' do
      expect(due_on_new.to_s)
        .to eq 'id: nil, day: 25, month: 3, year: nil, Destroy?: false'
    end

    describe '<=>' do
      it 'matches when equal' do
        expect(due_on_new(day: 2, month: 2) <=>
          due_on_new(day: 2, month: 2)).to eq(0)
      end

      it 'a is > b return 1' do
        expect(due_on_new(day: 2, month: 2) <=>
          due_on_new(day: 2, month: 1)).to eq(1)
      end

      it 'a is < b return -1' do
        expect(due_on_new(day: 2, month: 2) <=>
          due_on_new(day: 2, month: 3)).to eq(-1)
      end

      it 'nil when not comparable' do
        expect(due_on_new(day: 2, month: 2) <=> 37).to be_nil
      end
    end
  end
end
