require 'spec_helper'

describe Charges do

  let(:charges) { Account.new.charges }

  it '#prepare' do
    expect(charges).to have(0).items
    charges.prepare
    expect(charges).to have(4).items
  end

  it '#cleans up form' do
    charge = charges.build charge_attributes
    charge.due_ons.build due_on_attributes_0
    charges.build
    charges.clean_up_form
    expect(charges.reject(&:empty?)).to have(1).items
  end

  context 'with valid charge' do
    charge = nil
    before(:each) do
      charge = charges.build charge_attributes
      charge.id = 1
      due_on = charge.due_ons.build due_on_attributes_0
    end

    context '#first_or_initialize' do

      it 'initializes if not found' do
        expect(charges.first_or_initialize 'first seen').to \
          be_empty
      end

      it 'return if found' do
        expect(charges.first_or_initialize 'Ground Rent').to_not \
          be_empty
      end
    end

    context 'debts' do

      it 'applies debt between date' do
        expect(charges.charges_between Date.new(2013,3,30)..Date.new(2013,3,31)).to \
        eq [ DebtInfo.from_charge(charge_id: 1, \
                                  on_date: Date.new(2013,3,31), \
                                  amount: BigDecimal.new(88.08,8)) \
           ]
      end
    end
  end
end