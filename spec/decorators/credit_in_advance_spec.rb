require 'spec_helper'

describe CreditInAdvanceDecorator do

  let(:credit_dec) { CreditInAdvanceDecorator.new credit_new }

  it 'has the amount' do
    expect(credit_dec.amount).to eq '88.08'
  end

  it 'has the expected amount' do
    (charge = charge_new amount: 88.08).save!
    CreditInAdvanceDecorator.any_instance.stub(:charge).and_return charge

    expect(credit_dec.expected_amount).to eq '&pound;88.08'
  end

  context 'has expected date' do
    before { Timecop.travel(Date.new(2013, 5, 31)) }
    after  { Timecop.return }
    it 'due_on' do
      (charge = charge_new).save!
      CreditInAdvanceDecorator.any_instance.stub(:charge).and_return charge
      expect(credit_dec.expected_date).to eq Date.new 2013, 9, 30
    end
  end
end