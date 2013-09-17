require 'spec_helper'

describe Debt do

  let(:debt) { Debt.new charge_id: 1, on_date: '2013/01/30', amount: 10.05 }
  let(:account) { Account.new id: 1, property_id: 1 }

  it 'is valid' do
    expect(debt).to be_valid
  end

  context 'validates' do
    context 'presence' do
      it 'charge_id' do
        debt.charge_id = nil
        expect(debt).to_not be_valid
      end
      it 'on_date' do
        debt.on_date = nil
        expect(debt).to_not be_valid
      end
    end

    context 'amount' do
      it 'One penny is valid' do
        debt.amount = 0.01
        expect(debt).to be_valid
      end

      it 'two digits only' do
        debt.amount = 0.00001
        expect(debt).to_not be_valid
      end

      it 'positive numbers' do
        debt.amount = -1.00
        expect(debt).to_not be_valid
      end
    end
  end

end
