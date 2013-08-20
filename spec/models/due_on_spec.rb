require 'spec_helper'

describe DueOn do
  let(:be_due) { DueOn.new day: 1, month: 1, charge_id: 1 }
  let(:charge) { Charge.new charge_type: 'ground_rent', due_in: 'advance', amount: 500.50, property_id: 1 }

  it('is valid') { expect(be_due).to be_valid }

  context 'validates' do
    context 'presence' do
      it('day') { be_due.day = nil; expect(be_due).not_to be_valid }
      it('month') { be_due.month = nil; expect(be_due).not_to be_valid }
      it('charge id') { be_due.charge_id = nil; expect(be_due).not_to be_valid }
    end

    context 'numerical' do
      it('day numeric') { be_due.day = 'ab'; expect(be_due).to_not be_valid }
      it('day integer') { be_due.day = 8.3; expect(be_due).to_not be_valid }
      it('day not negative') { be_due.day = -3; expect(be_due).to_not be_valid}
      it('day not less than 32') { be_due.day = 32; expect(be_due).to_not be_valid}
      it('month numeric') { be_due.month = 'ab'; expect(be_due).to_not be_valid }
      it('month integer') { be_due.month = 8.3; expect(be_due).to_not be_valid }
      it('month not negative') { be_due.month = -3; expect(be_due).to_not be_valid}
      it('month not less than 13') { be_due.month = 13; expect(be_due).to_not be_valid}
    end
  end

  context 'associations' do
    it 'belongs to a charge' do
      be_due = charge.due_on.new day: 1, month: 1, charge_id: 1
      charge.save!
      expect(be_due.charge).to eq charge
    end
  end
end
