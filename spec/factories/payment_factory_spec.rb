require 'spec_helper'

describe 'payment' do
  let(:payment) { payment_new }

  it 'valid' do
    expect(payment).to be_valid
  end

  context 'changes date' do
    it 'on payment' do
      payment = payment_new on_date: '2012-03-25'
      expect(payment.on_date).to eq Date.new(2012, 03, 25)
    end
  end

  context 'credit' do
    before :each do
      payment.credits << credit_new
    end

    it 'present' do
      expect(payment.credits.first.amount).to eq 88.08
    end
    it 'has debit' do
      debit = payment.credits.first.debit
      expect(debit.amount).to eq 88.08
    end

    it 'add later date' do
      payment.credits << credit_new(on_date: '2014-03-25')
      expect(payment.credits.last.on_date).to eq Date.new(2014, 03, 25)
    end

    it 'can be saved' do
      expect{payment.save! }.to_not raise_error
    end
  end
end
