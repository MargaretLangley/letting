require 'spec_helper'

describe Account do


  let(:account) { Account.create! id: 1, property_id: 1  }

  it 'is valid' do
    expect(account).to be_valid
  end

  it 'makes payments' do
    payment = payment_factory
    account.payment payment
  end

  it 'returns the lastest payments' do
    transactions = []
    1.times { transactions << account.debt(debt_factory) }
    2.times { transactions << account.payment(payment_factory) }
    account.save!
    expect(AccountEntry.all.to_a).to eq transactions
    expect(Account.lastest_payments(2)).to eq transactions.reverse[0..1]
  end

  def debt_factory
    Debt.new charge_id: 1, on_date: '1/30/2013', amount: 10.05
  end

  def payment_factory
    Payment.new charge_id: 1, on_date: '1/30/2013', amount: 10.05
  end

end
