require 'spec_helper'

describe CreditDecorator do

  let(:credit_dec) { CreditDecorator.new credit_new }

  it 'has the #amount - keeps sign' do
    credit_dec = CreditDecorator.new credit_new amount: 20.00
    expect(credit_dec.amount).to eq '20.00'
  end

  context 'owing' do

    it 'none' do
      expect(credit_dec.owing).to eq 0
    end

    it 'sums debit' do
      Debit.create! debit_attributes on_date: '2013-03-30', amount: 50.08
      Debit.create! debit_attributes on_date: '2013-06-30', amount: 50.00
      expect(credit_dec.owing).to eq 100.08
    end
  end
end
