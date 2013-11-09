require 'spec_helper'

describe AccountDebitDecorator do

  let(:debit_dec) { AccountDebitDecorator.new debit_new }

  context 'attributes has' do
    it 'charge_type' do
      debit_dec.charge = Charge.new charge_attributes
      expect(debit_dec.charge_type).to eq 'Ground Rent'
    end

    it 'date' do
      expect(debit_dec.date).to eq '25/03/2013'
    end

    it 'due' do
      expect(debit_dec.due).to eq '88.08'
    end

    it 'payment' do
      expect(debit_dec.payment).to eq ''
    end

    it 'balance' do
      expect(debit_dec.balance).to eq 88.08
    end
  end
end