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
      payment.account = nil
      expect(payment).to_not be_valid
    end
  end

  context 'associations' do
    it('credits') { expect(payment).to respond_to(:credits) }
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

    context '#exists?' do
      it 'true if account known' do
        payment = Payment.new
        payment.account = Account.new id: 100
        expect(payment).to be_exists
      end

      it 'false if no account' do
        payment = Payment.new
        payment.account = nil
        expect(payment).to_not be_exists
      end
    end

    context '#search' do

      it('returns payments on searched date') do
        property = property_create!
        payment = Payment.create! payment_attributes account_id: property
          .account.id
        expect(Payment.search(Date.current.to_s)).to eq [payment]
      end

      it('payments on none-searched dates not returned') do
        property = property_create!
        Payment.create! payment_attributes account_id: property.account.id
        expect((Payment.search('2000-1-1'))).to eq []
      end

      context 'returns nothing' do
        it('on empty string') do
          property = property_create!
          Payment.create! payment_attributes account_id: property.account.id
          expect((Payment.search(''))).to eq []
        end

        it('on corrupt date') do
          property = property_create!
          Payment.create! payment_attributes account_id: property.account.id
          expect((Payment.search('2012-x'))).to eq []
        end
      end
    end
  end
end
