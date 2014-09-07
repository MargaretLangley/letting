# rubocop: disable  Lint/UselessComparison
require 'rails_helper'

describe Debit, :ledgers, type: :model do

  let(:account) { Account.new id: 1, account_id: 1 }
  it('is valid') { expect(debit_new).to be_valid }

  describe 'validates' do
    describe 'presence' do
      it('charge_id') { expect(debit_new charge_id: nil).to_not be_valid }
      it('on_date') { expect(debit_new on_date: nil).to_not be_valid }
      it('amount') { debit_new amount: nil }
    end
    describe 'amount' do
      it('is a number') { expect(debit_new(amount: 'nan')).to_not be_valid }
      it('has a max') { expect(debit_new(amount: 100_000)).to_not be_valid }
      it('is valid under max') do
        expect(debit_new(amount: 99_999.99)).to be_valid
      end
      it('has a min') { expect(debit_new(amount: -100_000)).to_not be_valid }
      it('is valid under max') do
        expect(debit_new(amount: -99_999.99)).to be_valid
      end
    end
  end

  describe 'class method' do
    describe '.available' do
      it 'orders debits by date' do
        last  = debit_create on_date: Date.new(2013, 4, 1)
        first = debit_create on_date: Date.new(2012, 4, 1)
        expect(Debit.available first.charge_id).to eq [first, last]
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
        expect { debit.charge_type }.to raise_error
      end
    end

    describe '#outstanding' do
      it 'returns amount if nothing paid' do
        expect(debit_new.outstanding).to eq 88.08
      end

      it 'multiple credits are added' do
        credit_create amount: -44.04
        (debit = debit_new).save!
        expect(debit.outstanding).to eq 44.04
      end
    end

    describe '#paid?' do
      it 'false without credit' do
        debit = debit_create amount: 88.08
        debit.save!
        expect(debit).to_not be_paid
      end

      it 'true when paid in full' do
        debit = debit_create amount: 88.08
        credit_create amount: -88.08
        debit.save!
        expect(debit).to be_paid
      end
    end

    describe '#==' do
      it 'returns equal objects as being the same' do
        expect(debit_new == debit_new).to be true
      end

      it 'returns unequal objects as being different' do
        expect(debit_new(charge_id: 1) == debit_new(charge_id: 2)).to be false
      end

      it 'returns nil objects are different classes' do
        expect(debit_new == 'I am a string not a debit').to be_nil
      end
    end
  end
end
