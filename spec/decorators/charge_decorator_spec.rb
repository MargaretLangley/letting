require 'rails_helper'

RSpec.describe ChargeDecorator do
  describe '#emphasis' do
    it 'can be emphasized' do
      charge = ChargeDecorator.new charge_new
      expect(charge.emphasis).to eq ''
    end

    it 'can be deemphasized' do
      charge = ChargeDecorator.new charge_new dormant: true
      expect(charge.emphasis).to eq 'deemphasized'
    end
  end
  describe '#dormant' do
    it 'returns true' do
      charge = ChargeDecorator.new charge_new dormant: false
      expect(charge.dormant).to eq 'No'
    end
    it 'returns false' do
      charge = ChargeDecorator.new charge_new dormant: true
      expect(charge.dormant).to eq 'Yes'
    end
  end
  describe '#pay' do
    it 'returns automatic' do
      charge = ChargeDecorator
               .new charge_new payment_type: Charge::STANDING_ORDER
      expect(charge.pay).to eq 'Automatic'
    end
    it 'returns payment' do
      charge = ChargeDecorator
               .new charge_new payment_type: Charge::PAYMENT
      expect(charge.pay).to eq 'Payment'
    end
  end
end
