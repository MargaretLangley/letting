require 'spec_helper'

describe CreditWithDebitDecorator do

  let(:credit) { CreditWithDebitDecorator.new credit_new }

  context '#prepare_for_form' do
    it 'nil amount set to pay off the debit' do
      credit.stub(:pay_off_debit).and_return 40
      credit.amount = nil

      credit.prepare_for_form
      amount_set_to_pay_off_debit
    end

    it 'none 0 amount unchanged' do
      credit.stub(:pay_off_debit).and_return 40
      credit.amount = 80

      credit.prepare_for_form
      amount_is_unchanged
    end
  end

  def amount_set_to_pay_off_debit
    expect(credit.amount).to eq 40
  end

  def amount_is_unchanged
    expect(credit.amount).to eq 80
  end
end
