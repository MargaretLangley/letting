require 'spec_helper'

describe PaymentDecorator do

  let(:source) { payment_new }
  let(:payment) { PaymentDecorator.new source }

  context 'methods' do

    context '#prepare_for_form' do
      before :each do
        source.stub(:account_exists?).and_return true
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

      it 'generates #credits_with_debits' do
        payment = generate_payment_for_account_with_debit

        payment.prepare_for_form

        expect(payment.credits_with_debits).to have(1).items
      end

      it 'generates #credit_in_advance' do
        payment = generate_payment_for_account_with_charge

        payment.prepare_for_form

        expect(payment.credits_in_advance).to have(1).items
      end

      def generate_payment_for_account_with_debit
        (account = account_and_debit).save!
        PaymentDecorator.new payment_new account_id: account.id
      end

      def generate_payment_for_account_with_charge
        (account = account_and_charge_new).save!
        PaymentDecorator.new payment_new account_id: account.id
      end
    end

    context '#property' do
      it 'returns the property' do
        property = property_create!
        payment.account_id = property.account.id

        expect(payment.property_decorator.source).to eq property
      end
    end
  end

end