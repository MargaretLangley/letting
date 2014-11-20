require 'rails_helper'

describe AccountDebitDecorator do

  let(:debit_dec) { AccountDebitDecorator.new debit_new }

  context 'attributes has' do
    it 'charge_type' do
      debit_dec.charge = charge_new charge_type: 'Rent'
      expect(debit_dec.charge_type).to eq 'Rent'
    end

    it 'date' do
      expect(debit_dec.on_date).to eq Time.zone.local 2013, 3, 25, 0, 0, 0, '+0'
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
