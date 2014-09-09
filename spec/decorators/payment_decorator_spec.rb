require 'rails_helper'

describe PaymentDecorator do
  describe 'methods' do

    describe '#property' do
      it 'returns the property' do
        property = property_create account: account_new
        payment = PaymentDecorator.new payment_new
        payment.account_id = property.account.id

        expect(payment.property_decorator.source).to eq property
      end
    end
  end
end
