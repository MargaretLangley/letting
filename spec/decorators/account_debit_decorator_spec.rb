require 'spec_helper'

describe AccountDebitDecorator do

  let(:debit_dec) { AccountDebitDecorator.new debit_new }

  context 'attributes has' do
    it 'charge_type' do
      debit_dec.charge = Charge.new charge_attributes
      expect(debit_dec.charge_type).to eq 'Ground Rent'
    end

    it 'date' do
      expect(debit_dec.on_date).to eq Date.new 2013, 3, 25
    end

    it 'due' do
      expect(debit_dec.due).to eq '88.08'
    end

    it 'payment' do
      expect(debit_dec.payment).to eq ''
    end

    it 'amount' do
      expect(debit_dec.amount).to eq 88.08
    end
  end
end
