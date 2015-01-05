require 'rails_helper'

describe 'payment' do
  describe 'new' do
    describe 'default' do
      it('is not valid') { expect(payment_new).to_not be_valid }
      it 'is valid with account' do
        expect(payment_new account: account_new).to be_valid
      end
    end

    describe 'overrides' do
      it 'alters on date' do
        expect(payment_new(booked_on: '2012-03-25').booked_on)
          .to eq Date.new(2012, 03, 25)
      end
      it('alters amount') { expect(payment_new(amount: 1).amount).to eq 1 }
    end

    describe 'adds' do
      it 'credits' do
        payment = payment_new credit: credit_new
        expect(payment.credits.size).to eq 1
      end
    end
  end

  describe 'create' do
    describe 'default' do
      it 'is created' do
        expect { payment_create account: account_new }
          .to change(Payment, :count).by(1)
      end
      it 'has amount' do
        expect(payment_create(account: account_new).amount).to eq(-88.08)
      end
      it 'has date' do
        expect(payment_create(account: account_new).booked_on.to_date)
          .to eq Date.new 2013, 4, 30
      end
    end
    describe 'overrides' do
      it 'alters amount' do
        expect(payment_create(account: account_new, amount: 35.50).amount)
          .to eq(-35.50)
      end
      it 'alters date' do
        expect(payment_create(account: account_new,
                              booked_on: '10/6/2014').booked_on.to_date)
          .to eq Date.new 2014, 6, 10
      end

      # Payment works by adding a time to a date.
      # Easiest way is to freeze time.
      #
      it 'alters datetime' do
        new_time = Time.zone.local(2013, 9, 30, 2, 5, 6)
        Timecop.freeze(new_time)

        payment = payment_create account: account_new,
                                 booked_on: Time.zone.local(2013, 9, 30)
        expect(payment.booked_on)
          .to eq Time.zone.local(2013, 9, 30, 2, 5, 6)

        Timecop.return
      end
    end
  end
end
