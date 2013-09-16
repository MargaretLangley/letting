require 'spec_helper'

describe Account do

  let(:account) { Account.create! id: 1, property_id: 1  }

  it 'is valid' do
    expect(account).to be_valid
  end

  it 'makes payments' do
    payment = Payment.new charge_type: 'Rent', on_date: '1/30/2013', amount: 10.05
    account.payment payment
  end
end
