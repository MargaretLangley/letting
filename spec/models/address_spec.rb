require 'spec_helper'

describe Address do

  let(:address) { Address.new address_attributes addressable_id: 1}

  it 'valid' do
    expect(address).to be_valid
  end

  it 'is associated with a addressable' do
    expect(address).to respond_to(:addressable)
  end

end
