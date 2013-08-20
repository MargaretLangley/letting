require 'spec_helper'

describe DueOn do
  let(:due_on) { DueOn.new day: 1, month: 1, charge_id: 1 }
  let(:charge) { Charge.new charge_type: 'ground_rent', due_in: 'advance', amount: 500.50, property_id: 1 }

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
  end

  context 'associations' do
    it 'belongs to a charge' do
      due_on = charge.due_ons.build day: 1, month: 1, charge_id: 1
      charge.save!
      expect(due_on.charge).to eq charge
    end
  end
end
