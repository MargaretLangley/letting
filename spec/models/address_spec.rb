require 'spec_helper'

describe Address do

  let(:address) { Address.new address_attributes contact_id: 1}

  it 'valid' do
    expect(address).to be_valid
  end

  it 'must have a reference to a contact' do
    address.contact_id = nil
    expect(address).not_to be_valid
  end

  it 'is associated with a contact' do
    expect(address).to respond_to(:contact)
  end

end
