require 'spec_helper'

describe Charge do
  let(:charge) do
    charge = Charge.new id: 1, charge_type: 'ground_rent', \
      due_in: 'advance', amount: 500.50, property_id: 1
    charge.due_ons.new  day: 3, month: 5, charge_id: 1
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
          (1..12).each { charge.due_ons.build day: 3, month: 5 }
          expect(charge).to_not be_valid
        end
        it 'valid if marked for destruction' do
          (1..12).each { charge.due_ons.build day: 3, month: 5 }
          charge.due_ons.first.mark_for_destruction
          expect(charge).to be_valid
        end
      end
    end
  end

  context 'Assocations' do
    it('is DueOns') { expect(charge).to respond_to(:due_ons) }

    it 'has due ones' do
      expect(charge.due_ons).to have(1).items
    end

    it 'prepares to display by creating extra due_ons' do
      charge.prepare
      expect(charge.due_ons).to have(4).items
    end

    it 'on marks for distruction empty items' do
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
  end


  context 'due between' do

    it 'missing due on' do
      expect(charge.due_between? Date.new(2013, 4, 1) .. Date.new(2013, 5, 2) ).to be_false
    end

    it 'is between due on' do
      expect(charge.due_between? Date.new(2013, 5, 1) .. Date.new(2013, 5, 5)).to be_true
    end

  end

  it 'makes charge if between'  do
    debt = DebtInfo.from_charge charge_id: 1, \
                        on_date: Date.new(2013,5,3), \
                        amount: BigDecimal.new(500.5,8)
    expect(charge.make_debt Date.new(2013, 5, 1) .. Date.new(2013, 5, 5) ).to eq debt
  end

end
