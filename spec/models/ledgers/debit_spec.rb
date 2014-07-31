require 'spec_helper'

describe Debit, type: :model do

  let(:debit) { Debit.new debit_attributes }
  let(:account) { Account.new id: 1, account_id: 1 }
  it('is valid') { expect(debit).to be_valid }

  describe 'validates' do
    describe 'presence' do

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
    describe 'amount' do
      it 'is numeric' do
        debit.amount = 'nnn'
        expect(debit).to_not be_valid
      end
      it 'has a maximum' do
        debit.amount = 100_000
        expect(debit).to_not be_valid
      end
    end

  end

  describe 'class method' do
    describe '.available' do

      it 'orders debits by date' do
        last  = create_debit Date.new(2013, 4, 1)
        first = create_debit Date.new(2012, 4, 1)
        expect(Debit.available first.charge_id).to eq [first, last]
      end

      def create_debit on_date
        Debit.create! debit_attributes on_date: on_date
      end
    end
  end

  describe 'methods' do

    describe '#charge_type' do
      it 'returned when charge present' do
        debit.charge = Charge.new charge_attributes
        expect(debit.charge_type).to eq 'Ground Rent'
      end

      it 'errors when charge missing' do
        expect { debit.charge_type }.to raise_error
      end
    end

    describe '#outstanding' do
      it 'returns amount if nothing paid' do
        expect(debit.outstanding).to eq 88.08
      end

      it 'multiple credits are added' do
        Credit.create! credit_attributes amount: 44.04
        debit.save!
        expect(debit.outstanding).to eq 44.04
      end
    end

    describe '#paid?' do
      it 'false without credit' do
        debit  = Debit.create! debit_attributes amount: 88.08
        debit.save!
        expect(debit).to_not be_paid
      end

      it 'true when paid in full' do
        debit  = Debit.create! debit_attributes amount: 88.08
        Credit.create! credit_attributes amount: 88.08
        debit.save!
        expect(debit).to be_paid
      end
    end

    describe '#==' do
      it 'returns equal objects as being the same' do
        lhs = Debit.new debit_attributes
        rhs = Debit.new debit_attributes
        expect(lhs == rhs).to be true
      end

      it 'returns unequal objects as being different' do
        lhs = Debit.new debit_attributes charge_id: 101
        rhs = Debit.new debit_attributes charge_id: 100
        expect(lhs == rhs).to be false
      end

      it 'returns nil objects are different classes' do
        lhs = Debit.new debit_attributes
        rhs = 'I am a string not a debit'
        expect(lhs == rhs).to be_nil
      end
    end
  end
end
