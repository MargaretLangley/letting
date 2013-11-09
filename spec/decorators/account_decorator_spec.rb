require 'spec_helper'

describe AccountDecorator do

  let(:account) do
    account = account_and_charge_new
    account.debits.push debit_new id: nil
    account.debits.push debit_new id: nil, on_date: '25/3/2012'
    account.credits.push credit_new
    account.save!
    AccountDecorator.new account
  end

  it 'sorted on date' do
    expect(account.items.first.date).to eq '25/03/2012'
    expect(account.items.last.date).to eq '30/04/2013'
  end
end