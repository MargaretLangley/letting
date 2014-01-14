require 'spec_helper'

describe PaymentDecorator do

  let(:source) { payment_new }
  let(:payment) { PaymentDecorator.new source }

  context 'methods' do

    context '#property' do
      it 'returns the property' do
        property = property_create!
        payment.account_id = property.account.id

        expect(payment.property_decorator.source).to eq property
      end
    end
  end

end