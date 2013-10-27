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

    it 'has amount' do
      expect(payment.on_date).to eq Date.new 2013, 9, 30
    end

  end

  context 'methods' do

    it '#prepare_for_form prepares credit' do
      property_with_unpaid_debit.save!
      payment = Payment.new human_ref: 2002
      payment.account =  Account.by_human_ref 2002
      payment.prepare_for_form
      expect(payment.credits).to have(1).items
    end

    it 'prepare_for_form calcualtes default amount' do
      payment.credits.build amount: 44.08
      payment.credits.build amount: 44.00
      payment.prepare_for_form
      expect(payment.amount).to eq 88.08
    end

  end

  context '#search' do

    it('no string returns empty') do
      property = property_create!
      Payment.create! payment_attributes account_id: property.account.id
      expect((Payment.search(''))).to eq []
    end

    it('corrupt date empty ') do
      property = property_create!
      Payment.create! payment_attributes account_id: property.account.id
      expect((Payment.search('2012-x'))).to eq []
    end

    it('on created date') do
      property = property_create!
      payment = Payment.create! payment_attributes account_id: property
        .account.id
      expect(Payment.search(Date.current.to_s)).to eq [payment]
    end

    it('not created date') do
      property = property_create!
      Payment.create! payment_attributes account_id: property.account.id
      expect((Payment.search('2000-1-1'))).to eq []
    end

  end

end
