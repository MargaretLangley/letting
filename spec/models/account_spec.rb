require 'spec_helper'

describe Account do

  let(:account) { Account.create! id: 1, property_id: 1  }

  it 'is valid' do
    expect(account).to be_valid
  end

  it 'makes payments' do
    expect(account.payment payment_attributes ).to be_valid
  end

  it 'makes debts' do
    expect(account.debt debt_attributes ).to be_valid
  end

  it 'lists unpaid debts' do
    debt1 = account.debt debt_attributes
    debt2 = account.debt debt_attributes charge_id: 2
    account.save!
    account.payment payment_attributes debt_id: debt1.id
    account.save!
    expect(Debt.all.to_a).to eq [debt1, debt2]
    expect(account.unpaid_debts).to eq [ debt2 ]
  end



  it 'returns the payments most recent first' do
    payments = []
    3.times { payments << account.payment(payment_attributes) }
    account.save!
    expect(Payment.all.to_a).to eq payments
    expect(Account.lastest_payments(2)).to eq payments.reverse[0..1]
  end

end
