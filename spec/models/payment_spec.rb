require 'spec_helper'

describe Payment do

  let(:payment) { Payment.new payment_attributes }
  it('is valid') { expect(payment).to be_valid }

  context 'validation' do
    it 'requires account' do
      payment.account_id = nil
      expect(payment).to_not be_valid
    end
    it 'requires date' do
      payment.on_date = nil
      expect(payment).to_not be_valid
    end
    it 'requires amount' do
      payment.amount = nil
      expect(payment).to_not be_valid
    end
  end

  context 'default inialization' do
    let(:payment) { Payment.new }
    before { Timecop.travel(Date.new(2013, 9, 30)) }
    after { Timecop.return }

    it 'has on_date' do
      expect(payment.on_date).to eq Date.new 2013, 9, 30
    end
  end

  context 'methods' do

    context '#account_exists?' do
      it 'true if account known' do
        payment.account = Account.new id: 100
        expect(payment).to be_account_exists
      end

      it 'false if no account' do
        payment.account = nil
        expect(payment).to_not be_account_exists
      end
    end

    context '#prepare' do
      before :each do
        payment.account = account_new
      end
      it 'handles no credits' do
        payment.prepare
        expect(payment.credits.size).to eq(0)
      end
      it 'adds returned credits' do
        payment.account.stub(:charges).and_return [ charge_new ]
        payment.prepare
        expect(payment.credits.size).to eq(1)
      end
    end

    context '#clear_up' do
      it 'removes credits with no amounts' do
        credit = payment.credits.build amount: 0
        payment.clear_up
        expect(credit).to be_marked_for_destruction
      end

      it 'saves credits with none-zero amount' do
        credit = payment.credits.build amount: 10
        payment.clear_up
        expect(credit).to_not be_marked_for_destruction
      end
    end

    describe '#payments_on' do

      it('returns payments on queried day') do
        property = property_create!
        payment = Payment.create! payment_attributes account_id: property
          .account.id
        expect(Payment.payments_on(Date.current.to_s)).to eq [payment]
      end

      it('returns nothing on days without a transaction.') do
        property = property_create!
        Payment.create! payment_attributes account_id: property.account.id
        expect((Payment.payments_on('2000-1-1'))).to eq []
      end

      it('returns nothing if invalid date') do
        property = property_create!
        Payment.create! payment_attributes account_id: property.account.id
        expect((Payment.payments_on('2012-x'))).to eq []
      end
    end
  end
end
