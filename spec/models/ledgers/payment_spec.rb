require 'rails_helper'

describe Payment, :payment, :ledgers, type: :model do
  describe 'validates' do
    it('is valid') { expect(payment_new account: account_new).to be_valid }
    it 'requires account' do
      expect(payment_new(account_id: nil)).to_not be_valid
    end
    describe 'amount' do
      it('requires amount') { expect(payment_new amount: nil).to_not be_valid }
      it('is a number') { expect(payment_new amount: 'nan').to_not be_valid }
      it('has a max') { expect(payment_new amount: 100_000).to_not be_valid }
      it 'is valid under max' do
        expect(payment_new account: account_new, amount: 99_999.99).to be_valid
      end
      it('has a min') { expect(payment_new amount: -100_000).to_not be_valid }
      it 'is valid under min' do
        expect(payment_new account: account_new, amount: -99_999.99).to be_valid
      end
      it('fails zero amount') { expect(payment_new amount: 0).to_not be_valid }
    end
    it 'requires date' do
      payment = payment_new
      # note: default_initialization for booked_on
      payment.booked_on = nil
      expect(payment).to_not be_valid
    end
  end

  describe 'initialize' do
    # changing for Date to DateTime - so I want test to fail if we use date
    before { Timecop.travel Time.local(2013, 9, 30, 2, 0) }
    after  { Timecop.return }
    describe 'booked_on' do
      it 'sets nil booked_on to today' do
        expect(payment_new(booked_on: nil).booked_on)
          .to be_within(1.second).of Time.zone.now
      end
      it 'leaves defined booked_on intact' do
        payment = payment_create account: account_new,
                                 booked_on: Time.local(2013, 9, 30, 2, 0)
        expect(payment.booked_on).to eq Time.local(2013, 9, 30, 2, 0)
      end
    end
    describe 'amount' do
      it 'sets nil amount to 0' do
        expect(payment_new(amount: nil).amount).to eq 0
      end
      it 'leaves defined amounts intact' do
        payment = payment_create account: account_new, amount: 10.50
        expect(Payment.find(payment.id).amount).to eq(-10.50)
      end
    end
  end

  describe 'methods' do
    describe '#account_exists?' do
      it 'true if account known' do
        (payment = payment_new).account = Account.new id: 100
        expect(payment).to be_account_exists
      end

      it 'false if no account' do
        (payment = payment_new).account = nil
        expect(payment).to_not be_account_exists
      end
    end

    describe '#prepare' do
      it 'handles no credits' do
        (payment = payment_new).account = account_new
        payment.prepare
        expect(payment.credits.size).to eq(0)
      end
      it 'adds returned credits' do
        (payment = payment_new).account = account_new
        allow(payment.account).to receive(:charges).and_return [charge_new]
        payment.prepare
        expect(payment.credits.size).to eq(1)
      end
    end

    describe '#negate' do
      it 'amount sign change' do
        payment = payment_new amount: -10
        payment.negate
        expect(payment.amount).to eq 10
      end
      it 'amount double sign change' do
        payment = payment_new amount: -10
        payment.negate.negate
        expect(payment.amount).to eq(-10)
      end
      it 'credit sign change' do
        payment = payment_new credit: credit_new(amount: -10)
        payment.negate
        expect(payment.credits.first.amount).to eq 10
      end
    end

    describe '#clear_up' do
      it 'removes credits with no amounts' do
        (payment = payment_new credit: credit_new(amount: 0)).clear_up
        expect(payment.credits.first).to be_marked_for_destruction
      end

      it 'saves credits with none-zero amount' do
        (payment = payment_new credit: credit_new(amount: 1)).clear_up
        expect(payment.credits.first).to_not be_marked_for_destruction
      end
    end
  end
end
