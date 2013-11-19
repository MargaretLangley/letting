require 'spec_helper'

describe CreditWithDebitDecorator do

  let(:credit_dec) { CreditWithDebitDecorator.new credit_new }

  it 'has the #amount' do
    expect(credit_dec.amount).to eq '88.08'
  end

  context '#prepare_for_form' do
    it 'nil amount set to pay off the debit' do
      credit_dec.stub(:pay_off_debit).and_return 40
      credit_dec.amount = nil

      credit_dec.prepare_for_form
      amount_set_to_pay_off_debit
    end

    it 'none 0 amount unchanged' do
      credit_dec.stub(:pay_off_debit).and_return 40
      credit_dec.amount = 80

      credit_dec.prepare_for_form
      amount_is_unchanged
    end
  end

  def amount_set_to_pay_off_debit
    expect(credit_dec.amount).to eq '40.00'
  end

  def amount_is_unchanged
    expect(credit_dec.amount).to eq '80.00'
  end
end
