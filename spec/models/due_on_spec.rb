require 'spec_helper'

describe DueOn do

  let(:due_on) { DueOn.new due_on_attributes_0 charge_id: 1 }
  it('is valid') { expect(due_on).to be_valid }

  context 'validates' do
    context 'presence' do
      it 'day' do
        due_on.day = nil
        expect(due_on).not_to be_valid
      end

      it 'month' do
        due_on.month = nil
        expect(due_on).not_to be_valid
      end
    end

    context 'numerical' do

      it 'day numeric' do
        due_on.day = 'ab'
        expect(due_on).to_not be_valid
      end

      it 'day integer' do
        due_on.day = 8.3
        expect(due_on).to_not be_valid
      end

      it 'day not negative' do
        due_on.day = -3
        expect(due_on).to_not be_valid
      end

      it 'day not less than 32' do
        due_on.day = 32
        expect(due_on).to_not be_valid
      end

      it 'month numeric' do
        due_on.month = 'ab'
        expect(due_on).to_not be_valid
      end

      it 'month integer' do
        due_on.month = 8.3
        expect(due_on).to_not be_valid
      end

      it 'month not negative' do
        due_on.month = -3
        expect(due_on).to_not be_valid
      end

      it 'month not less than 13' do
        due_on.month = 13
        expect(due_on).to_not be_valid
      end
    end
  end

  context 'associations' do
    it('has charge') { expect(due_on).to respond_to :charge }
  end

  context 'methods' do
    context '#empty?' do
      it 'valid not empty' do
        expect(due_on).to_not be_empty
      end
      it 'no day or month is empty' do
        due_on.day = nil
        due_on.month = nil
        expect(due_on).to be_empty
      end
    end

    context '#per_month?' do
      it 'recognises when not per month' do
        due_on.day = 25
        due_on.month = 3
        expect(due_on).to_not be_per_month
      end
      it 'recognises per month' do
        due_on.day = 25
        due_on.month = -1
        expect(due_on).to be_per_month
      end
    end
  end

  context '#between?' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after { Timecop.return }

    it 'true' do
      expect(due_on.between? charge_due_on_date).to be_true
    end

    it 'false' do
      expect(due_on.between? no_charge_on_dates).to be_false
    end

    def charge_due_on_date
      Time.new(2013, 3, 25) .. Date.new(2013, 3, 25)
    end

    def no_charge_on_dates
      Date.new(2013, 2, 25) .. Date.new(2013, 3, 24)
    end
  end

  context '#makedate' do
    it 'this year before charge on_date' do
      Timecop.travel(Date.new(2014, 3, 25))
      expect(due_on.make_date).to eq Date.new(2014, 3, 25)
      Timecop.return
    end

    it 'next year after charge on_date' do
      Timecop.travel(Date.new(2014, 3, 26))
      expect(due_on.make_date).to eq Date.new(2015, 3, 25)
      Timecop.return
    end
  end
end
