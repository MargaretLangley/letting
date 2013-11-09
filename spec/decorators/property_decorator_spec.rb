require 'spec_helper'

describe PropertyDecorator do

  let(:property) { PropertyDecorator.new property_new }

  context 'client_ref' do
    it 'returns nil if unknown' do
      expect(property.client_ref).to eq nil
    end

    it 'returns ref when known' do
      property.client = client_new
      expect(property.client_ref).to eq 8008
    end
  end

  it 'writes flat property' do
    expect(property.address_lines[0]).to eq 'Mr W G Grace'
    expect(property.address_lines[1]).to eq 'Flat 47'
    expect(property.address_lines[2]).to eq 'Hillbank House'
    expect(property.address_lines[3]).to eq '294 Edgbaston Road'
    expect(property.address_lines[4]).to eq 'Edgbaston'
    expect(property.address_lines[5]).to eq 'Birmingham'
    expect(property.address_lines[6]).to eq 'West Midlands'
    expect(property.address_lines[7]).to eq 'B5 7QU'
  end

  let(:house) do
    property.address.flat_no = ''
    property.address.house_name = ''
    property
  end

  it 'writes house from road' do
    expect(house.address_lines[1]).to eq '294 Edgbaston Road'
  end
end
