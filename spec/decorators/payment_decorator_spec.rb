require 'spec_helper'

describe PaymentDecorator do

  let(:source) { payment_new }
  let(:payment) { PaymentDecorator.new source }

  context 'prepare_for_form' do

    it 'leaves amount if set' do
      payment.prepare_for_form
      expect(payment.amount).to eq 88.08
    end

    it 'sets amount if nil to outstanding' do
      source.stub(:outstanding).and_return 50.05
      payment.amount = nil
      payment.prepare_for_form
      expect(payment.amount).to eq 50.05
    end
  end
end