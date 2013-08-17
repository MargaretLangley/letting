require 'spec_helper'

describe Entity do

  let(:entity) { Entity.new person_entity_attributes entitieable_id: 1 }

  it ('is valid') { expect(entity).to be_valid }

  context 'associations' do
    it 'with an entitieable' do
      expect(entity).to respond_to(:entitieable)
    end
  end

  context 'validations' do
    it('presence #name') { entity.name = nil; expect(entity).to_not be_valid }
  end

  context 'methods #empty? new entity' do
    let(:entity) { Entity.new }
    it('empty') { expect(entity).to be_empty }
    it('with noted attribute not empty') { entity.name = 'Bob'; expect(entity).to_not be_empty }
    it('with ignored attribute empty') { entity.id = 8; expect(entity).to be_empty}
  end

  it ('name cannot be blank') { entity.name = ''; expect(entity).to_not be_valid }
  it ('name has a maximum length') { entity.name = 'a' * 41; expect(entity).to_not be_valid }

  it ('title has a maximum length') { entity.title = 'a' * 11; expect(entity).to_not be_valid }
  it ('initials has a maximum length') { entity.initials = 'a' * 11; expect(entity).to_not be_valid }
end


