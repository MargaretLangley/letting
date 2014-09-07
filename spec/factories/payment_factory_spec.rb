require 'rails_helper'

describe 'payment' do

  describe 'payment_new' do
    describe 'default' do
      it('is valid') { expect(payment_new).to be_valid }
    end

    describe 'override' do
      it 'on date' do
        expect(payment_new(on_date: '2012-03-25').on_date)
          .to eq Date.new(2012, 03, 25)
      end
      it('changes amount') { expect(payment_new(amount: 1).amount).to eq 1 }
    end

    describe 'adds' do
      it 'credits' do
        payment = payment_new credit: credit_new
        expect(payment.credits.size).to eq 1
      end
    end
  end

  describe 'create' do
    it 'is created' do
      expect { payment_create }.to change(Payment, :count).by(1)
    end
    describe 'default' do
      it('has amount') { expect(payment_create.amount).to eq(-88.08) }
      it('has date') do
        expect(payment_create.on_date.to_date).to eq Date.new 2013, 4, 30
      end
    end
    describe 'override' do
      it 'alters amount' do
        expect(payment_create(amount: 35.50).amount).to eq(-35.50)
      end
      it 'alters date' do
        expect(payment_create(on_date: '10/6/2014').on_date.to_date)
          .to eq Date.new 2014, 6, 10
      end
    end
  end
end
