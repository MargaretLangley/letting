require 'spec_helper'

describe 'Credit Factory' do

  let(:credit) { credit_new }
  it('is valid') { expect(credit).to be_valid }

  it 'creates advanced credit' do
    credit = credit_in_advance_new
    expect(credit).to be_advance
    expect(credit.debit_id).to be_nil
  end

end
