require 'spec_helper'

describe AccountCreditDecorator do

  let(:credit_dec) { AccountCreditDecorator.new credit_new }

  context 'attributes has' do
    it 'charge_type' do
      credit_dec.charge = Charge.new charge_attributes
      expect(credit_dec.charge_type).to eq 'Ground Rent'
    end

    it 'date' do
      expect(credit_dec.on_date).to eq Date.new 2013, 4, 30
    end

    it 'due' do
      expect(credit_dec.due).to eq ''
    end

    it 'payment' do
      expect(credit_dec.payment).to eq '88.08'
    end

    it 'balance' do
      expect(credit_dec.balance).to eq(-88.08)
    end
  end
end
