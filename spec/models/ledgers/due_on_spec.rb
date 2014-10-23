require 'rails_helper'

# rubocop: disable Style/Documentation
# rubocop: disable Style/SpaceInsideRangeLiteral
# rubocop: disable Style/TrivialAccessors
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
    describe '#between' do
      it 'returns the repeated dates that are present in the range' do
        expect(due_on_new(month: 3, day: 25)
          .between Date.new(2013, 3, 25)..Date.new(2013, 3, 25))
            .to eq [Date.new(2013, 3, 25)]
      end

      it 'handles date time' do
        expect(due_on_new(month: 3, day: 25)
          .between DateTime.new(2007, 8, 17, 11, 56, 00)..
                   DateTime.new(2008, 8, 16, 11, 56, 00))
            .to eq [Date.new(2008, 3, 25)]
      end

      it 'handles multi-year' do
        expect(due_on_new(month: 3, day: 5)
          .between Date.new(2010, 3, 1)..Date.new(2012, 3, 6))
            .to eq [Date.new(2010, 3, 5),
                    Date.new(2011, 3, 5),
                    Date.new(2012, 3, 5)]
      end

      it 'empty return when not matching' do
        expect(due_on_new(month: 1, day: 1)
          .between Date.new(2013, 3, 25)..Date.new(2013, 3, 25)).to eq []
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

    # public as it is called by due_ons.empty?
    describe '#empty?' do
      it 'with attributes not empty' do
        expect(due_on_new month: 3, day: 25).to_not be_empty
      end
      it 'without attributes empty' do
        expect(due_on_new day: nil, month: nil).to be_empty
      end
    end

    describe '#<=>' do
      it 'returns 0 when equal' do
        expect(due_on_new(month: 2, day: 2) <=>
          due_on_new(month: 2, day: 2)).to eq(0)
      end

      it 'returns 1 when lhs > rhs' do
        expect(due_on_new(month: 2, day: 2) <=>
          due_on_new(month: 1, day: 2)).to eq(1)
      end

      it 'returns -1 when lhs < rhs' do
        expect(due_on_new(month: 2, day: 2) <=>
          due_on_new(month: 3, day: 2)).to eq(-1)
      end

      it 'returns nil when not comparable' do
        expect(due_on_new(month: 2, day: 2) <=> 37).to be_nil
      end
    end

    describe '#to_s' do
      it 'outputs day and month without year' do
        expect(due_on_new.to_s).to eq '[Mar 25]'
      end

      it 'outputs year, month, day with year' do
        expect(due_on_new(year: 2002).to_s).to eq '[2002 Mar 25]'
      end

      it 'displays if marked for destruction' do
        (due_on = due_on_new).mark_for_destruction
        expect(due_on.to_s).to eq '[Mar 25 MFD]'
      end
    end
  end
end
