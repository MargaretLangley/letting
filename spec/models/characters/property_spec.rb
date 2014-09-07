require 'rails_helper'

describe Property, type: :model do

  let(:property) { property_new }
  it('is valid') { expect(property).to be_valid }

  describe 'validations' do
    describe 'human_ref' do

      it 'is present' do
        property.human_ref = nil
        expect(property).to_not be_valid
      end

      it 'is a number' do
        property.human_ref = 'Not numbers'
        expect(property).to_not be_valid
      end

      it '#human_ref is unique' do
        property_create human_ref: 8000
        expect { property_create human_ref: 8000 }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

    describe 'client_id' do
      it('required') do
        property.client_id = nil
        expect(property).to_not be_valid
      end

      it '#numeric' do
        property.client_id = 'Not numbers'
        expect(property).to_not be_valid
      end
    end
  end

  describe 'Methods' do

    describe '#bill_to' do
      let(:property) { property_new }

      it 'property with no agent' do
        expect(property.bill_to).to eq property
      end

      it 'agent when using it' do
        property.agent.authorized = true
        expect(property.bill_to).to eq property.agent
      end
    end
  end

  describe 'search', :slow do

    before :each do
      property_create
      Property.import force: true, refresh: true
    end

    after :each do
      Property.__elasticsearch__.delete_index!
    end

    describe '.search' do
      it('human id') { expect(Property.search('2002').results.total).to eq 1 }
      it('names') { expect(Property.search('Grac').results.total).to eq 1 }
      it('house') { expect(Property.search('Hil').results.total).to eq 1 }
      it('roads') { expect(Property.search('Edg').results.total).to eq 1 }
      it('towns') { expect(Property.search('Bir').results.total).to eq 1 }
    end
  end
end
