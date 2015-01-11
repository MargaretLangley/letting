require 'rails_helper'

describe Payments do
  describe 'methods' do
    it 'to_a' do
      payment1 = payment_create(account: account_new, amount: 10)
      payment2 = payment_create(account: account_new, amount: 20)
      payments = Payments.new [payment1, payment2]
      expect(payments.to_a).to eq [payment1, payment2]
    end

    it 'sum' do
      # payments will be created with negative amounts
      payment1 = payment_create(account: account_new, amount: 10)
      payment2 = payment_create(account: account_new, amount: 20)
      payments = Payments.new [payment1, payment2]
      expect(payments.sum).to eq 30
    end

    describe '.last_booked_at' do
      it 'returns today if no payments at all (unlikely)' do
        expect(Payments.last_booked_at).to eq Time.zone.today.to_s
      end

      it 'returns the last day a payment was made' do
        payment_create(account: account_new, booked_at: '2014-03-25')
        payment_create(account: account_new, booked_at: '2014-06-25')
        expect(Payments.last_booked_at).to eq '2014-06-25'
      end
    end

    describe '#on' do
      it 'returns payments on queried day' do
        account = account_create property: property_new
        payment = payment_create account_id: account.id,
                                 booked_at: '2014-9-1 16:29:30'
        expect(Payments.on(date: '2014-09-01').to_a).to eq [payment]
      end

      it 'returns nothing on days without a transaction.' do
        account = account_create property: property_new
        payment_create account_id: account.id
        expect(Payments.on(date: '2000-1-1').to_a).to eq []
      end

      it 'returns nothing if invalid date' do
        account = account_create property: property_new
        payment_create account_id: account.id
        expect(Payments.on date: '2012-x').to eq []
      end
    end
  end
end
