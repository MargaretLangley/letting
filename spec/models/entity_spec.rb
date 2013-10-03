require 'spec_helper'

describe Entity do

  let(:entity) { Entity.new person_entity_attributes entitieable_id: 1 }
  it('is valid') { expect(entity).to be_valid }

  context 'associations' do
    it('is entitieable') { expect(entity).to respond_to(:entitieable) }
  end

  context 'validations' do
    context 'name' do

      it 'presence' do
        entity.name = nil
        expect(entity).to_not be_valid
      end

      it 'cannot be blank' do
        entity.name = ''
        expect(entity).to_not be_valid
      end

      it 'has a maximum' do
        entity.name = 'a' * 65
        expect(entity).to_not be_valid
      end
    end
    context 'entity_type' do
      it 'presence' do
        entity.entity_type = nil
        expect(entity).to_not be_valid
      end
    end

    it 'title has a max' do
      entity.title = 'a' * 11
      expect(entity).to_not be_valid
    end

    it 'initials has a max' do
      entity.initials = 'a' * 11
      expect(entity).to_not be_valid
    end
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

      it 'with noted attribute not empty' do
        entity.name = 'Bob'
        expect(entity).to_not be_empty
      end

      it 'with ignored attribute empty' do
        entity.id = 8
        expect(entity).to be_empty
      end
    end
  end

end
