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

    it '#prepare_for_form creates credit' do
      property_with_unpaid_debit.save!
      payment =  PaymentDecorator.new payment_new human_ref: 2002
      payment.account =  Account.by_human_ref 2002
      payment.prepare_for_form
      expect(payment.credits).to have(1).items
    end

  end

  context '#clear_up_form' do
    it 'removes empty credits' do
      Credit.any_instance.stub(:outstanding).and_return(0)
      payment.source.credits.build
      payment.clear_up_form
      expect(payment.credits.first).to be_marked_for_destruction
    end
  end
end