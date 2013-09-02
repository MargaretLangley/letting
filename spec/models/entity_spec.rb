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
    context '#name' do
      it('presence') { entity.name = nil; expect(entity).to_not be_valid }
      it ('cannot be blank') { entity.name = ''; expect(entity).to_not be_valid }
      it ('has a maximum length') { entity.name = 'a' * 65; expect(entity).to_not be_valid }
    end
    context '#entity_type' do
      it('presence') { entity.entity_type = nil; expect(entity).to_not be_valid }
    end
    it ('#title has a maximum length') { entity.title = 'a' * 11; expect(entity).to_not be_valid }
    it ('#initials has a maximum length') { entity.initials = 'a' * 11; expect(entity).to_not be_valid }
  end

  context 'methods' do
    let(:entity) { Entity.new }
    context '#prepare new entity' do
      it 'has entity_type' do
        entity.prepare
        expect(entity.entity_type).to eq 'Person'
      end
    end
    context '#empty? new entity' do
      it('empty') { expect(entity).to be_empty }
      it('with noted attribute not empty') { entity.name = 'Bob'; expect(entity).to_not be_empty }
      it('with ignored attribute empty') { entity.id = 8; expect(entity).to be_empty}
    end
  end

end


