require 'spec_helper'

describe 'Property Factory' do

  it 'saves a property factory' do
    property = property_factory
    expect(property.id).to_not eq nil
  end

  it 'id changeable' do
    property = property_factory id: 2
    expect(property.id).to eq 2
  end

  it 'creates with human_id' do
    property = property_factory
    expect(property.human_id).to eq 2002
  end

  it 'human_id changeable' do
    property = property_factory human_id: 3001
    expect(property.human_id).to eq 3001
  end
end