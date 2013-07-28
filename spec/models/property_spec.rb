require 'spec_helper'

describe Property do

  let(:property) { Property.new human_property_reference: 8000 }

  it ('is valid') { expect(property).to be_valid }

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

  context '::contact' do

    context '#addresses' do
      it 'location returns an address' do
        property.build_address address_attributes road_no: 3456
        expect(property.address.road_no).to eq 3456
      end
    end

  end
end