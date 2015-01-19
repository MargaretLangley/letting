require 'rails_helper'

describe ClientPayment, :ledgers do
  it 'creates years' do
    payment = ClientPayment.query
    expect(payment.years).to eq %w(2015 2014 2013 2012 2011)
  end

  it 'calculates #total_period' do
    cpay = ClientPayment.query
    expect(cpay.total_period(year: 2012, month: ClientPayment::MAR_SEP.first))
      .to eq Time.zone.local(2012, 3, 1, 00, 00, 00)..
             Time.zone.local(2012, 9, 1, 00, 00, 00)
  end
end
