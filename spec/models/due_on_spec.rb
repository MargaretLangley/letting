require 'spec_helper'

describe DueOn do

  let(:due_on) { DueOn.new due_on_attributes_0 charge_id: 1 }
  it('is valid') { expect(due_on).to be_valid }

  describe 'Attribute' do
    describe 'day' do
      it 'presence' do
        due_on.day = nil
        expect(due_on).to_not be_valid
      end

      it 'numeric' do
        due_on.day = 'ab'
        expect(due_on).to_not be_valid
      end

      it 'integer' do
        due_on.day = 8.3
        expect(due_on).to_not be_valid
      end

      it 'greater than 0' do
        due_on.day = 0
        expect(due_on).to_not be_valid
      end

      it 'not less than 32' do
        due_on.day = 32
        expect(due_on).to_not be_valid
      end
    end

    context 'month' do
      it 'presence' do
        due_on.month = nil
        expect(due_on).to_not be_valid
      end

      it 'numeric' do
        due_on.month = 'ab'
        expect(due_on).to_not be_valid
      end

      it 'integer' do
        due_on.month = 8.3
        expect(due_on).to_not be_valid
      end

      it 'not negative' do
        due_on.month = -3
        expect(due_on).to_not be_valid
      end

      it 'not less than 13' do
        due_on.month = 13
        expect(due_on).to_not be_valid
      end
    end

    describe 'year' do

      it 'numeric' do
        due_on.year = 'ab'
        expect(due_on).to_not be_valid
      end

      it 'integer' do
        due_on.year = 8.3
        expect(due_on).to_not be_valid
      end

      it 'not less than 1990' do
        due_on.year = 1989
        expect(due_on).to_not be_valid
      end

      it 'less than 2030' do
        due_on.year = 2030
        expect(due_on).to_not be_valid
      end

    end
  end

  describe 'methods' do

    describe '#monthly?' do
      it 'recognises when not per month' do
        due_on.day = 25
        due_on.month = 3
        expect(due_on).to_not be_monthly
      end
      it 'recognises per month' do
        due_on.day = 25
        due_on.month = -1
        expect(due_on).to be_monthly
      end
    end

    describe '#between?' do
      before { Timecop.travel Date.new 2013, 1, 31 }
      after { Timecop.return }

      it 'true range covers due_on' do
        expect(due_on.between? charge_due_on_date).to be_true
      end

      it 'false range misses due_on' do
        expect(due_on.between? no_charge_on_dates).to be_false
      end

      def charge_due_on_date
        Time.new(2013, 3, 25) .. Date.new(2013, 3, 25)
      end

      def no_charge_on_dates
        Date.new(2013, 2, 25) .. Date.new(2013, 3, 24)
      end
    end

    describe '#clear_up_form' do
      it 'is destroyed when empty' do
        pending
      end
    end

    describe '#makedate' do
      it 'this year before charge on_date' do
        Timecop.travel Date.new 2014, 3, 25
        expect(due_on.make_date).to eq Date.new(2014, 3, 25)
        Timecop.return
      end

      it 'next year after charge on_date' do
        Timecop.travel Date.new 2014, 3, 26
        expect(due_on.make_date).to eq Date.new(2015, 3, 25)
        Timecop.return
      end

      context 'year set' do
        it 'uses the set year' do
          Timecop.travel Date.new 2014, 3, 25
          due_on.year = 2015
          expect(due_on.make_date).to eq Date.new(2015, 3, 25)
          Timecop.return
        end
      end
    end

    describe '#empty?' do
      it 'with attributes not empty' do
        expect(due_on).to_not be_empty
      end
      it 'without attributes empty' do
        due_on.day = nil
        due_on.month = nil
        expect(due_on).to be_empty
      end
    end
  end
end
