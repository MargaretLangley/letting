require 'spec_helper'

describe 'Property Factory' do

  it 'not saves' do
    property = property_new
    expect(property.id).to eq nil
  end

  it 'id changeable' do
    property = property_new id: 2
    expect(property.id).to eq 2
  end

  it 'creates with human_id' do
    property = property_new
    expect(property.human_id).to eq 2002
  end

  it 'human_id changeable' do
    property = property_new human_id: 3001
    expect(property.human_id).to eq 3001
  end

  context 'nested attributes' do

    it 'has nested attributes' do
      property = property_new human_id: 3001
      expect(property.address.road).to eq 'Edgbaston Road'
    end

    it 'changes nested attributes' do
      property = property_new human_id: 3001,
                              address_attributes: { road: 'Headingly Road' }
      expect(property.address.road).to eq 'Headingly Road'
    end
  end
end
