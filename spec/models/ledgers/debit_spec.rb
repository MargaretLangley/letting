# rubocop: disable  Lint/UselessComparison
require 'rails_helper'

describe Debit, :ledgers, type: :model do
  describe 'validates' do
    let(:debit) { charge_new(debits: [debit_new]).debits.first }
    it('is valid') { expect(debit).to be_valid }
    describe 'presence' do
      it 'charge required but missing' do
        (debit = debit_new).valid?
        expect(debit.errors.first).to eq [:charge, "can't be blank"]
      end
      it 'on_date' do
        debit.on_date = nil
        expect(debit).to_not be_valid
      end
      it('amount') { debit_new amount: nil }
    end
    describe 'amount' do
      it('is a number') { expect(debit_new(amount: 'nan')).to_not be_valid }
      it 'has a max' do
        expect(debit_new(charge: charge_new, amount: 100_000)).to_not be_valid
      end
      it('is valid under max') do
        debit.amount = 99_999.99
        expect(debit).to be_valid
      end
      it 'has a min' do
        expect(debit_new(charge: charge_new, amount: -100_000)).to_not be_valid
      end
      it('is valid under max') do
        debit.amount = -99_999.99
        expect(debit).to be_valid
      end
      it('fails zero amount') { expect(debit_new amount: 0).to_not be_valid }
    end
  end

  describe 'class method' do
    describe '.available' do
      it 'orders debits by date' do
        last  = debit_new on_date: Date.new(2013, 4, 1)
        first = debit_new on_date: Date.new(2012, 4, 1)
        charge = charge_create debits: [last, first]

        expect(Debit.available charge.id).to eq [first, last]
      end
    end
  end

  describe 'methods' do

    describe '#charge_type' do
      it 'returned when charge present' do
        (debit = debit_new).charge = charge_new charge_type: 'Rent'
        expect(debit.charge_type).to eq 'Rent'
      end

      it 'errors when charge missing' do
        expect { debit_new.charge_type }.to raise_error
      end
    end

    describe '#outstanding' do
      it 'returns amount if nothing paid' do
        expect(debit_new.outstanding).to eq 88.08
      end

      it 'multiple credits are added' do
        charge = charge_create(debits:  [debit_new(amount: 88.08)],
                               credits: [credit_new(amount: -44.04)])
        charge.save!
        expect(Debit.first.outstanding).to eq 44.04
      end
    end

    describe '#paid?' do
      it 'false without credit' do
        charge = charge_new debits: [debit_new(amount: 88.08)]
        charge.save!
        expect(Debit.first).to_not be_paid
      end

      it 'true when paid in full' do
        charge = charge_new(debits:  [debit_new(amount: 88.08)],
                            credits: [credit_new(amount: -88.08)])
        charge.save!
        expect(Debit.first).to be_paid
      end
    end

    describe '#==' do
      it 'returns equal objects as being the same' do
        expect(debit_new == debit_new).to be true
      end

      it 'returns unequal objects as being different' do
        expect(debit_new(amount: 1) == debit_new(amount: 2)).to be false
      end

      it 'returns nil objects are different classes' do
        expect(debit_new == 'I am a string not a debit').to be_nil
      end
    end
  end
end
