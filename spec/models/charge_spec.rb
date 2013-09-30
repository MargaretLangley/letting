require 'spec_helper'

describe Charge do
  let(:charge) do
    charge = Charge.new charge_attributes id: 1
    charge.due_ons.new due_on_attributes_0 charge_id: 1
    charge
  end

  it('is valid') { expect(charge).to be_valid }

  context 'validations' do
    context 'presence' do
      it('charge type') { charge.charge_type = nil; expect(charge).to_not be_valid }
      it('due in') { charge.due_in = nil; expect(charge).to_not be_valid }
      it('amount') {charge.amount = nil; expect(charge).to_not be_valid}
      it('due_ons') {charge.due_ons.destroy_all; expect(charge).to_not be_valid}
      context 'due_ons_size' do
        it 'not valid one over limit' do
          (1..12).each { charge.due_ons.build day: 25, month: 3 }
          expect(charge).to_not be_valid
        end
        it 'valid if marked for destruction' do
          (1..12).each { charge.due_ons.build day: 25, month: 3 }
          charge.due_ons.first.mark_for_destruction
          expect(charge).to be_valid
        end
      end
    end
  end

  context 'Assocations' do
    it('belongs to property') { expect(charge).to respond_to(:property) }
    it('is DueOns') { expect(charge).to respond_to(:due_ons) }
  end

  context 'methods' do

    it '#prepare creates children' do
      charge.prepare
      expect(charge.due_ons).to have(4).items
    end

    it '#clean_up_form destroys children' do
      charge.clean_up_form
      expect(charge.due_ons).to have(1).items
    end

    context '#empty?' do
      it 'valid is not empty' do
        expect(charge).to_not be_empty
      end

      it 'charge is not empty if due_ons not empty' do
        charge.attributes = { charge_type: '', due_in: '', amount: '' }
        expect(charge).to_not be_empty
      end

      it 'if charge and due_ons attributes empty' do
        charge.attributes = { charge_type: '', due_in: '', amount: '' }
        charge.due_ons[0].attributes = { day: nil, month: nil }
        expect(charge).to be_empty
      end
    end

    context '#due_between?' do
      before { Timecop.travel(Time.zone.parse('31/1/2013 12:00')) }
      after { Timecop.return }

      it 'missing due on' do
        expect(charge.due_between? Date.new(2013, 2, 1) .. Date.new(2013, 3, 24) ).to be_false
      end

      it 'is between due on' do
        expect(charge.due_between? Date.new(2013, 3, 25) .. Date.new(2013, 3, 25)).to be_true
      end
    end

    context '#makes_debt' do
      before { Timecop.travel(Time.zone.parse('31/1/2013 12:00')) }
      after  { Timecop.return }

      it 'if charge between dates'  do
        debt = DebtInfo.from_charge charge_id: 1, \
                            on_date: Date.new(2013,3,25), \
                            amount: 88.08
        expect(charge.make_debt Date.new(2013, 2, 25) .. Date.new(2013, 3, 25) ).to eq debt
      end
    end
  end
end
