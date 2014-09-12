require 'rails_helper'

describe 'payment' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(payment_new).to be_valid }
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
        expect { payment_create }.to change(Payment, :count).by(1)
      end
      it('has amount') { expect(payment_create.amount).to eq(-88.08) }
      it('has date') do
        expect(payment_create.booked_on.to_date).to eq Date.new 2013, 4, 30
      end
    end
    describe 'overrides' do
      it 'alters amount' do
        expect(payment_create(amount: 35.50).amount).to eq(-35.50)
      end
      it 'alters date' do
        expect(payment_create(booked_on: '10/6/2014').booked_on.to_date)
          .to eq Date.new 2014, 6, 10
      end
    end
  end
end
