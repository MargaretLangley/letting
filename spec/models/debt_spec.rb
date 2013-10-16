require 'spec_helper'

describe Debt do

  let(:debt) { Debt.new debt_attributes }
  let(:account) { Account.new id: 1, account_id: 1 }
  it('is valid') { expect(debt).to be_valid }

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

  context 'methods' do

    context '#already_charged' do
      it 'matches' do
        one = Debt.new(charge_id: 1, on_date: '2013-10-1')
        two = Debt.new(charge_id: 1, on_date: '2013-10-1')
        expect(one.already_charged?(two)).to be_true
      end
      it 'charge causes false' do
        one = Debt.new(charge_id: 1, on_date: '2013-10-1')
        two = Debt.new(charge_id: 2, on_date: '2013-10-1')
        expect(one.already_charged?(two)).to be_false
      end
      it 'date causes false' do
        one = Debt.new(charge_id: 1, on_date: '2013-10-1')
        two = Debt.new(charge_id: 1, on_date: '2014-10-1')
        expect(one.already_charged?(two)).to be_false
      end
    end

    context '#paid' do
      it 'returns 0 if nothing paid' do
        expect(debt.paid).to eq 0
      end

      it 'returns the amount paid' do
        debt.save!
        Credit.create! credit_attributes debt_id: debt.id
        expect(debt.paid).to eq 88.08
      end

      it 'multiple credits are added' do
        debt.save!
        Credit.create! credit_attributes amount: 1.05, debt_id: debt.id
        Credit.create! credit_attributes amount: 1.05, debt_id: debt.id
        expect(debt.paid).to eq 2.10
      end
    end

    context '#paid?' do
      it 'false without credit' do
        expect(debt).to_not be_paid
      end

      it 'true when paid in full' do
        debt.save!
        Credit.create! credit_attributes debt_id: debt.id
        expect(debt).to be_paid
      end
    end
  end
end
