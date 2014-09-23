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

    describe '.last_booked_on' do
      before { Timecop.travel '2014-06-25' }
      after { Timecop.return }

      it 'returns today if no payments at all (unlikely)' do
        expect(Payments.last_booked_on).to eq '2014-06-25'
      end

      it 'returns the last day a payment was made' do
        payment_create(account: account_new, booked_on: '2014-03-25')
        payment_create(account: account_new, booked_on: '2014-06-25')
        expect(Payments.last_booked_on).to eq '2014-06-25'
      end
    end

    describe '#on' do
      it 'returns payments on queried day' do
        account = property_create(account: account_new).account
        payment = payment_create account_id: account.id,
                                 booked_on: '1/Sep/2014 16:29:30 +0100'
                                            .to_datetime
        expect(Payments.on(date: '2014-09-01').to_a).to eq [payment]
      end

      it 'returns nothing on days without a transaction.' do
        account = property_create(account: account_new).account
        payment_create account_id: account.id
        expect(Payments.on(date: '2000-1-1').to_a).to eq []
      end

      it 'returns nothing if invalid date' do
        account = property_create(account: account_new).account
        payment_create account_id: account.id
        expect(Payments.on date: '2012-x').to eq []
      end
    end
  end

end
