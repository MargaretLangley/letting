require 'spec_helper'

describe 'payment' do
  let(:payment) { payment_new }

  it 'valid' do
    expect(payment).to be_valid
  end

  context 'credit' do
    it 'present' do
      expect(payment.credits.first.amount).to eq 88.08
    end
    it 'has debit' do
      debit = payment.credits.first.debit
      expect(debit.amount).to eq 88.08
    end
  end
end