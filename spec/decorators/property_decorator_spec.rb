require 'spec_helper'

describe PropertyDecorator do

  let(:property) { PropertyDecorator.new property_new }

  let(:house) do
    property.address.flat_no = ''
    property.address.house_name = ''
    property
  end

  context 'client_ref' do
    it 'returns nil if unknown' do
      expect(property.client_ref).to eq nil
    end

    it 'returns ref when known' do
      property.client = client_new
      expect(property.client_ref).to eq 8008
    end
  end

  it 'writes flat name' do
    expect(property.address_name).to eq 'Mr W. G. Grace'
  end

  it 'writes flat property' do
    expect(property.address_lines[0]).to eq 'Flat 47 Hillbank House'
  end

  it 'generates abbrivated address' do
    expect(property.abbreviated_address).to eq 'Flat 47 Hillbank House'
  end
end
