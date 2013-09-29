require 'spec_helper'

describe DueOn do

  let(:due_on) { DueOn.new day: 3, month: 5, charge_id: 1 }
  let(:charge) { Charge.new charge_attributes account_id: 1 }
  it('is valid') { expect(due_on).to be_valid }

  context 'validates' do
    context 'presence' do
      it('day') { due_on.day = nil; expect(due_on).not_to be_valid }
      it('month') { due_on.month = nil; expect(due_on).not_to be_valid }
    end

    context 'numerical' do
      it('day numeric') { due_on.day = 'ab'; expect(due_on).to_not be_valid }
      it('day integer') { due_on.day = 8.3; expect(due_on).to_not be_valid }
      it('day not negative') { due_on.day = -3; expect(due_on).to_not be_valid}
      it('day not less than 32') { due_on.day = 32; expect(due_on).to_not be_valid}
      it('month numeric') { due_on.month = 'ab'; expect(due_on).to_not be_valid }
      it('month integer') { due_on.month = 8.3; expect(due_on).to_not be_valid }
      it('month not negative') { due_on.month = -3; expect(due_on).to_not be_valid}
      it('month not less than 13') { due_on.month = 13; expect(due_on).to_not be_valid}
    end
  end

  context 'associations' do
    it 'belongs to a charge' do
      due_on = charge.due_ons.build day: 3, month: 5, charge_id: 1
      charge.save!
      expect(due_on.charge).to eq charge
    end
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
        due_on.day = 3
        due_on.month = 5
        expect(due_on).to_not be_per_month
      end
      it 'recognises per month' do
        due_on.day = 3
        due_on.month = -1
        expect(due_on).to be_per_month
      end
    end
  end

  context 'due between' do
    before { Timecop.travel(Time.zone.parse('3/5/2013 12:00')) }
    after { Timecop.return }

    it 'before due on' do
      expect(due_on.between? Date.new(2013,4,1) .. Date.new(2013, 5, 2) ).to be_false
    end

    it 'is between due on' do
      expect(due_on.between? Time.new(2013,5,1) .. Date.new(2013,5,5)).to be_true
    end

    it 'after due on' do
      expect(due_on.between? Date.new(2013, 5, 4) ..  Date.new(2013, 5, 7) ).to be_false
    end

    context 'timetravel' do
      it 'knows the year' do
        Timecop.travel(Time.zone.parse('3/5/2014 12:00'))
        expect(due_on.make_date).to eq Date.new(2014,5,3)
        Timecop.return
      end

      it 'allows for next year' do
        Timecop.travel(Time.zone.parse('4/5/2014 12:00'))
        expect(due_on.make_date).to eq Date.new(2015,5,3)
        Timecop.return
      end

      it 'allows for next year in december' do
        Timecop.travel(Time.zone.parse('1/12/2014 12:00'))
        expect(due_on.make_date).to eq Date.new(2015,5,3)
        Timecop.return
      end

    end

    it 'makes date' do
      Timecop.travel(Time.zone.parse('3/5/2013 12:00'))
      expect(due_on.make_date).to eq Date.new 2013, 5, 3
      Timecop.return
    end
  end
end
