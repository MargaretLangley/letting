require 'rails_helper'
# rubocop: disable Style/Documentation

class CreditValidatable
  include ActiveModel::Validations
  validates :amount, credit: true
  attr_accessor :amount

  def initialize amount
    @amount = amount
  end
end

describe 'Amount' do

  let(:validatable) { CreditValidatable.new 88.88 }

  it 'true' do
    expect(validatable).to be_valid
  end

  context 'invalid' do
    it 'large negative number' do
      validatable.amount = -100_000
      expect(validatable).to_not be_valid
    end
    it 'large positive number' do
      validatable.amount = 100_000
      expect(validatable).to_not be_valid
    end
    it 'nil' do
      validatable.amount = nil
      expect(validatable).to_not be_valid
    end
  end

  it 'sets error' do
    validatable.amount = -100_000
    validatable.valid?
    expect(validatable.errors[:amount].size).to eq(1)
  end
end
