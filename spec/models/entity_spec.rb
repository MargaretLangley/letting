require 'spec_helper'

describe Entity do

  let(:entity) { Entity.new person_entity_attributes entitieable_id: 1 }

  it ('is valid') { expect(entity).to be_valid }

  context 'associations' do
    it 'with an entitieable' do
      expect(entity).to respond_to(:entitieable)
    end
  end

  context 'validation' do
    it 'requires a name' do
      entity.name = nil
      expect(entity).to_not be_valid
    end
  end

  context 'methods' do

    context '#empty?' do
      let(:entity) { Entity.new}

      it 'new entity is empty' do
        expect(entity).to be_empty
      end

      it 'new entity with attribute set is not empty' do
        entity.title = 'Mr'
        expect(entity).to_not be_empty
      end

      it 'new entity with ignored attribute set is empty' do
        entity.id = 8
        expect(entity).to be_empty
      end
    end
  end
end


