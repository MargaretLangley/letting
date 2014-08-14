require 'rails_helper'

describe PaymentDecorator do

  let(:source) { payment_new }
  let(:payment) { PaymentDecorator.new source, human_ref: nil }

  describe 'methods' do

    describe '#property' do
      it 'returns the property' do
        property = property_create
        payment.account_id = property.account.id

        expect(payment.property_decorator.source).to eq property
      end
    end
  end

end
