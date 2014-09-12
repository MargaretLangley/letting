require 'rails_helper'

describe PaymentIndexDecorator do

  let(:source) { payment_new }
  let(:decorator) { PaymentIndexDecorator.new source }

  context 'methods' do
    it '#booked_on returned' do
      expect(decorator.booked_on).to eq '30 Apr 2013 00:00'
    end

    it '#amount' do
      expect(decorator.amount).to eq '&pound;88.08'
    end
  end
end
