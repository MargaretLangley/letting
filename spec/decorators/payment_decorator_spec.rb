require 'spec_helper'

describe PaymentDecorator do

  let(:source) { payment_new }
  let(:payment) { PaymentDecorator.new source }

  context 'methods' do

    context '#prepare_for_form' do
      before :each do
        source.stub(:prepareable?).and_return true
        source.stub(:prepare)
        source.stub(:outstanding).and_return 50.05
      end

      it 'set amounts left' do
        payment.amount = 60.05
        payment.prepare_for_form
        expect(payment.amount).to eq 60.05
      end

      it 'nil amounts to outstanding' do
        payment.amount = nil
        payment.prepare_for_form
        expect(payment.amount).to eq 50.05
      end
    end

    context '#credits' do
      it 'generates credit decorators' do
        # None zero amount stops CreditDirector msging Credit
        CreditDecorator.any_instance.stub(:amount).and_return 10.00
        payment.source.credits.build
        expect(payment.credits).to have(1).items
      end
    end
  end

end