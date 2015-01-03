require 'rails_helper'

describe ClientPayment, :ledgers do
  it 'creates years' do
    payment = ClientPayment.query(year: 2000)
    expect(payment.years).to eq %w(2015 2014 2013 2012 2011)
  end

  it 'calculates mar range' do
    payment = ClientPayment.query(year: 2012)
    expect(payment.mar_range).to eq Time.zone.local(2012, 3, 1, 00, 00, 00)..
                                    Time.zone.local(2012, 9, 1, 00, 00, 00)
  end

  it 'calculates sep range' do
    payment = ClientPayment.query(year: 2012)
    expect(payment.sep_range).to eq Time.zone.local(2012, 9, 1, 00, 00, 00)..
                                    Time.zone.local(2013, 2, 29, 00, 00, 00)
  end

  it 'calculates jun range' do
    payment = ClientPayment.query(year: 2012)
    expect(payment.jun_range).to eq Time.zone.local(2012, 6, 1, 00, 00, 00)..
                                    Time.zone.local(2012, 12, 1, 00, 00, 00)
  end

  it 'calculates dec range' do
    payment = ClientPayment.query(year: 2012)
    expect(payment.dec_range).to eq Time.zone.local(2012, 12, 1, 00, 00, 00)..
                                    Time.zone.local(2013, 6, 1, 00, 00, 00)
  end
end
