require 'spec_helper'

describe Debit do

  let(:debit) { Debit.new debit_attributes }
  let(:account) { Account.new id: 1, account_id: 1 }
  it('is valid') { expect(debit).to be_valid }

  context 'validates' do
    context 'presence' do

      it 'charge_id' do
        debit.charge_id = nil
        expect(debit).to_not be_valid
      end

      it 'on_date' do
        debit.on_date = nil
        expect(debit).to_not be_valid
      end

      it 'amount' do
        debit.amount = nil
        expect(debit).to_not be_valid
      end
    end

  end

  context 'methods' do

    context '#already_charged' do
      it 'matches' do
        one = Debit.new(charge_id: 1, on_date: '2013-10-1')
        two = Debit.new(charge_id: 1, on_date: '2013-10-1')
        expect(one.already_charged?(two)).to be_true
      end
      it 'charge causes false' do
        one = Debit.new(charge_id: 1, on_date: '2013-10-1')
        two = Debit.new(charge_id: 2, on_date: '2013-10-1')
        expect(one.already_charged?(two)).to be_false
      end
      it 'date causes false' do
        one = Debit.new(charge_id: 1, on_date: '2013-10-1')
        two = Debit.new(charge_id: 1, on_date: '2014-10-1')
        expect(one.already_charged?(two)).to be_false
      end
    end

    context '#paid' do
      it 'returns 0 if nothing paid' do
        expect(debit.paid).to eq 0
      end

      it 'returns the amount paid' do
        debit.save!
        Credit.create! credit_attributes debit_id: debit.id
        expect(debit.paid).to eq 88.08
      end

      it 'multiple credits are added' do
        debit.save!
        Credit.create! credit_attributes amount: 1.05, debit_id: debit.id
        Credit.create! credit_attributes amount: 1.05, debit_id: debit.id
        expect(debit.paid).to eq 2.10
      end
    end

    context '#paid?' do
      it 'false without credit' do
        expect(debit).to_not be_paid
      end

      it 'true when paid in full' do
        debit.save!
        Credit.create! credit_attributes debit_id: debit.id
        expect(debit).to be_paid
      end
    end
  end
end
