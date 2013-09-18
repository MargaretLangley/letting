require 'spec_helper'

describe Debt do

  let(:debt) { Debt.new debt_attributes }
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

    context 'paid' do

      it 'returns 0 if nothing paid' do
        expect(debt.paid).to eq 0
      end

      it 'returns the amount paid' do
        debt.save!
        payment = Payment.create! payment_attributes debt_id: debt.id
        expect(debt.paid).to eq 10.05
      end

      it 'returns the amount paid' do
        debt.save!
        Payment.create! payment_attributes amount: 1.05, debt_id: debt.id
        Payment.create! payment_attributes amount: 1.05, debt_id: debt.id
        expect(debt.paid).to eq 2.10
      end

    end

    context '#paid?' do

      it 'is not paid' do
        expect(debt).to_not be_paid
      end

      it 'paid in full true' do
        debt.save!
        Payment.create! payment_attributes debt_id: debt.id
        expect(debt).to be_paid
      end

    end

  end

end
