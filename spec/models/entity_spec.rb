require 'spec_helper'

describe Entity do

  let(:entity) { Entity.new person_entity_attributes entitieable_id: 1 }

  it 'is valid' do
    expect(entity).to be_valid
  end

  it 'must have a reference to a entitieable' do
    entity.entitieable_id = nil
    expect(entity).not_to be_valid
  end

  it 'is associated with a addressable' do
    expect(entity).to respond_to(:entitieable)
  end

  it 'requires a name' do
    entity.name = nil
    expect(entity).to_not be_valid
  end
end


