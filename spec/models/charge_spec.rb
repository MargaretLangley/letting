require 'spec_helper'

describe Charge do
  let(:charge) do
    charge = Charge.new charge_type: 'ground_rent', \
      due_in: 'advance', amount: 500.50, property_id: 1
    charge.be_dues.new  day: 1, month: 1, charge_id: 1
    charge
  end

  it('is valid') { expect(charge).to be_valid }

  context 'validations' do
    context 'presence' do
      it('charge type') { charge.charge_type = nil; expect(charge).to_not be_valid }
      it('due in') { charge.due_in = nil; expect(charge).to_not be_valid }
      it('amount') {charge.amount = nil; expect(charge).to_not be_valid}
      xit('be_dues') {charge.be_dues.destroy_all; expect(charge).to_not be_valid}
    end
  end

  context 'Assocations' do
    it('is bedues') { expect(charge).to respond_to(:be_dues) }
  end

end
