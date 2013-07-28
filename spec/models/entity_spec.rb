require 'spec_helper'

describe Entity do

  let(:entity) { Entity.new person_entity_attributes }
  it 'is valid' do
    expect(Entity.new person_entity_attributes).to be_valid
  end

  it 'requires a name' do
    entity.name = nil
    expect(entity).to_not be_valid
  end
end


