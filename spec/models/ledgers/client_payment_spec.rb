require 'rails_helper'

describe ClientPayment, :ledgers do
  it 'creates years' do
    payment = ClientPayment.query(year: 2000)
    expect(payment.years).to eq %w(2015 2014 2013 2012 2011)
  end

  it 'calculates mar range' do
    payment = ClientPayment.query(year: 2012)
    expect(payment.half_year_from(month: ClientPayment::MAR))
      .to eq Time.zone.local(2012, 3, 1, 00, 00, 00)..
             Time.zone.local(2012, 9, 1, 00, 00, 00)
  end
end
