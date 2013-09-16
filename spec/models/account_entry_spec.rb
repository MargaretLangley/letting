require 'spec_helper'

describe AccountEntry do

  let(:account_entry) { AccountEntry.new charge_id: 1, on_date: '2013/30/1', paid: 10.05 }
  let(:payment) { Payment.new charge_id: 1, on_date: '2013/30/1', amount: 10.50 }
  let(:account) { Account.new id: 1, property_id: 1 }

  it 'is valid' do
    expect(account_entry).to be_valid
  end

  context 'validates' do
    context 'presence' do
      it 'charge_id' do
        account_entry.charge_id = nil
        expect(account_entry).to_not be_valid
      end
      it 'on_date' do
        account_entry.on_date = nil
        expect(account_entry).to_not be_valid
      end
    end

    context 'amount' do
      it 'One penny is valid' do
        account_entry.paid = 0.01
        expect(account_entry).to be_valid
      end

      it 'two digits only' do
        account_entry = AccountEntry.new charge_id: 1, paid: 0.00001
        expect(account_entry).to_not be_valid
      end

      it 'positive numbers' do
        account_entry = AccountEntry.new charge_id: 1, paid: -1.00
        expect(account_entry).to_not be_valid
      end
    end
  end

  # it 'adds a payment', focus: true do
  #   entry = account.account_entries.payment payment
  #   expect(entry.charge_id).to eq 1
  # end

end
