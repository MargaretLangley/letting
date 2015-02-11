require 'rails_helper'

describe ClientPayment, :ledgers do
  it 'creates years' do
    payment = ClientPayment.query
    expect(payment.years).to eq %w(2015 2014 2013 2012 2011)
  end
end
