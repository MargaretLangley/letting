require 'spec_helper'

describe Property do

  let(:property) { Property.new human_property_reference: 8000 }

  it 'is valid' do
    expect(property).to be_valid
  end

  context '#human_property_reference' do
    it 'validates it is a number' do
      property.human_property_reference = "Not numbers"
      expect(property).to_not be_valid
    end
    it 'validates it is unique' do
      property.save
      expect { Property.create! human_property_reference: 8000 }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context '#addresses' do

    let(:property_with_address) do
      property.build_location_address address_attributes road_no: 3456
      property
    end

    it 'location returns an address' do
      expect(property_with_address.location_address.road_no).to eq 3456
    end
  end


end