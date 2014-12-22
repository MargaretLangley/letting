require 'rails_helper'
# rubocop: disable Style/Documentation

class AmountValidatable
  include ActiveModel::Validations
  validates :amount, amount: true
  attr_accessor :amount

  def initialize amount
    @amount = amount
  end
end

describe 'Amount' do
  def validator_new amount
    AmountValidatable.new amount
  end

  describe 'amount' do
    it('is a number') { expect(validator_new('nan')).to_not be_valid }
    it('has a max') { expect(validator_new(100_000)).to_not be_valid }
    it('is valid under max') do
      expect(validator_new(99_999.99)).to be_valid
    end
    it('has a min') { expect(validator_new(-100_000)).to_not be_valid }
    it('is valid under max') { expect(validator_new(-99_999.99)).to be_valid }
    it('fails zero amount') { expect(validator_new amount: 0).to_not be_valid }
  end

  it 'sets error' do
    validatable = validator_new(-100_000.01)
    validatable.valid?
    expect(validatable.errors[:amount].size).to eq(1)
  end
end
