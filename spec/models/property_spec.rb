require 'spec_helper'

describe Property do

  let(:property) { Property.new human_property_reference: 8000 }

  it 'is valid' do
    expect(property).to be_valid
  end

  it 'has an array of addresses' do
    expect(property.addresses).to eq([])
  end

  it 'responds with its created addreses' do
    property.addresses.build address_attributes road_no: 3456
    expect(property.addresses.map(&:road_no)).to eq([3456])
  end


end