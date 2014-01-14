require 'spec_helper'

describe CreditDecorator do

  let(:credit_dec) { CreditDecorator.new credit_new }

  it 'has the #amount' do
    expect(credit_dec.amount).to eq '88.08'
  end

  context 'owing' do

    it 'none' do
      expect(credit_dec.owing).to eq 0
    end

    it 'sums debit' do
      Debit.create! debit_attributes amount: 100.08
      expect(credit_dec.owing).to eq 100.08
    end
  end
end
