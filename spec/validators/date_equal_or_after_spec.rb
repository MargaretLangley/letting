require 'spec_helper'

class Validatable
  include ActiveModel::Validations
  validates_with DateEqualOrAfter
  attr_accessor  :start_date, :end_date

  def initialize start_date, end_date
    @start_date = start_date
    @end_date = end_date
  end
end

describe 'DateEqualOrAfter' do

  let(:validatable) do
    Validatable.new Date.new(2013, 1, 1), Date.new(2013, 1, 1)
  end

  it 'true' do
    expect(validatable).to be_valid
  end

  it 'false' do
    validatable.end_date = Date.new(2012, 12, 31)
    expect(validatable).to_not be_valid
  end

  it 'sets error' do
    validatable.end_date = Date.new(2012, 12, 31)
    validatable.valid?
    expect(validatable.errors[:end_date].size).to eq(1)
  end
end
