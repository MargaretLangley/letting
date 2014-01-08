require 'spec_helper'

class AmountValidatable
  include ActiveModel::Validations
  validates :amount, amount: true
  attr_accessor  :amount

  def initialize amount
    @amount = amount
  end
end

describe 'Amount' do

  let(:validatable) { AmountValidatable.new 88.88 }

  it 'true' do
    expect(validatable).to be_valid
  end

  context 'false' do
    it 'negative number' do
      validatable.amount = -1
      expect(validatable).to_not be_valid
    end
    it 'none numeric' do
      validatable.amount = 'bat'
      expect(validatable).to_not be_valid
    end
    it 'nil' do
      validatable.amount = nil
      expect(validatable).to_not be_valid
    end
  end

  it 'sets error' do
    validatable.amount = -0.01
    expect(validatable).to have(1).error_on(:amount)
  end

  context 'amount' do
    it 'One penny is valid' do
      validatable.amount = 0.01
      expect(validatable).to be_valid
    end

    it 'two digits only' do
      validatable.amount = 0.00001
      expect(validatable).to_not be_valid
    end

    it 'positive numbers' do
      validatable.amount = -1.00
      expect(validatable).to_not be_valid
    end
  end
end
