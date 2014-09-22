require 'rails_helper'

describe CreditDecorator do
  it 'has the #amount - keeps sign' do
    credit_dec = CreditDecorator.new credit_new amount: 20.00
    expect(credit_dec.amount).to eq '20.00'
  end

  context 'owing' do

    it 'none' do
      expect(CreditDecorator.new(credit_new).owing).to eq 0
    end

    it 'sums debit' do
      charge = charge_new
      debit_create charge: charge, on_date: '2013-03-30', amount: 50.08
      debit_create charge: charge, on_date: '2013-06-30', amount: 50.00
      credit_dec = CreditDecorator.new credit_new charge: charge
      expect(credit_dec.owing).to eq 100.08
    end
  end
end
