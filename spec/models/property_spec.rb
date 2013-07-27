require 'spec_helper'

describe Property do

  let(:property) { Property.new human_property_reference: 8000 }

  it 'is valid' do
    expect(property).to be_valid
  end

  context 'Address' do

    let(:property_with_location) do
      property.addresses.build address_attributes road_no: 3456
      property
    end

    it 'has array' do
      expect(property.addresses).to eq []
    end

    it 'responds with created addreses' do
      expect(property_with_location.addresses.map &:road_no).to eq [3456]
    end

    it 'location' do
      expect(property_with_location.location.road_no).to eq 3456
    end
  end


end