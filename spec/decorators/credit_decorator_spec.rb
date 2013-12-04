require 'spec_helper'

describe CreditDecorator do

  let(:credit_dec) { CreditDecorator.new credit_new }

  it 'has the #amount' do
    expect(credit_dec.amount).to eq '88.08'
  end
end
