require 'rails_helper'

describe PaymentIndexDecorator do

  let(:source) { payment_new }
  let(:decorator) { PaymentIndexDecorator.new source }

  context 'methods' do
    it '#on_date returned' do
      expect(decorator.on_date).to eq '30 Apr 2013'
    end

    it '#amount' do
      expect(decorator.amount).to eq '&pound;88.08'
    end
  end
end
