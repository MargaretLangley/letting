require 'rails_helper'

describe Payment, :ledgers, type: :model do

  context 'validation' do
    it('is valid') { expect(payment_new).to be_valid }
    it 'requires account' do
      expect(payment_new(account_id: nil)).to_not be_valid
    end
    it 'requires date' do
      payment = payment_new
      # note: default_initialization for on_date
      payment.on_date = nil
      expect(payment).to_not be_valid
    end

    it('requires amount') { expect(payment_new(amount: nil)).to_not be_valid }

    it('fails zero amount') { expect(payment_new(amount: 0)).to_not be_valid }
  end

  describe 'default inialization' do
    before { Timecop.travel(Date.new(2013, 9, 30)) }
    after { Timecop.return }
    it 'sets on_date to today' do
      expect(payment_new(on_date: nil).on_date).to eq Date.new 2013, 9, 30
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

    describe '#reverse_credits' do
      it 'changes credit sign' do
        payment = payment_new(credit: credit_new(amount: -10))
        payment.reverse_credits
        expect(payment.credits.first.amount).to eq 10
      end
    end

    describe '#clear_up' do
      it 'removes credits with no amounts' do
        (payment = payment_new(credit: credit_new(amount: 0))).clear_up
        expect(payment.credits.first).to be_marked_for_destruction
      end

      it 'saves credits with none-zero amount' do
        (payment = payment_new(credit: credit_new(amount: 1))).clear_up
        expect(payment.credits.first).to_not be_marked_for_destruction
      end
    end

    describe '#payments_on' do
      it('returns payments on queried day') do
        account = property_create(account: account_new).account
        payment = Payment.create! payment_attributes account_id: account.id
        expect(Payment.payments_on(Date.current.to_s)).to eq [payment]
      end

      it('returns nothing on days without a transaction.') do
        account = property_create(account: account_new).account
        Payment.create! payment_attributes account_id: account.id
        expect((Payment.payments_on('2000-1-1'))).to eq []
      end

      it('returns nothing if invalid date') do
        account = property_create(account: account_new).account
        Payment.create! payment_attributes account_id: account.id
        expect((Payment.payments_on('2012-x'))).to eq []
      end
    end
  end
end
