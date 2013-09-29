require 'spec_helper'

describe 'Account Factory' do

  let(:account) { account_new }

  it('no id'){ expect(account.id).to eq 1 }
  it('change id') do
    account = account_new id: 2
    expect(account.id).to eq 2
  end
  it('has property') { expect(account.property_id).to eq 1 }
  it('change property') do
    account = account_new property_id: 2
    expect(account.property_id).to eq 2
  end

  context 'charged' do

    let(:account) { account_and_charge_new }

    it('has charge') { expect(account.charges[0].charge_type).to eq 'Ground Rent' }
    context 'has due_on' do
      it('day') { expect(account.charges[0].due_ons[0].day).to eq 25 }
      it('month') { expect(account.charges[0].due_ons[0].month).to eq 3 }
    end
    context 'overrides' do
      it('charge') do
        account = account_and_charge_new charge_attributes: { charge_type: 'Rent' }
        expect(account.charges[0].charge_type).to eq 'Rent'
      end
      it('due on') do
        account = account_and_charge_new due_on_attribute: { month: 6 }
        expect(account.charges[0].due_ons[0].month).to eq 6
      end
    end
  end
end