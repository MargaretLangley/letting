require 'spec_helper'

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

      it 'is unique' do
        property.save!
        property.id = nil # dirty way of saving it again
        expect { property.save! human_ref: 8000 }
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

    describe '#prepare_for_form' do
      let(:property) do
        property = Property.new human_ref: 8000
        property.prepare_for_form
        property
      end

      it 'builds required models' do
        expect(property.address).to_not be_nil
        expect(property.entities.size).to eq(2)
        expect(property.agent).to_not be_nil
      end

      it 'builds no more than the required models' do
        property.prepare_for_form  # * 2
        expect(property.address).to_not be_nil
        expect(property.entities.size).to eq(2)
        expect(property.agent).to_not be_nil
      end

      it '#clear_up_form destroys unused models' do
        property.clear_up_form
        expect(property.address).to_not be_nil
        expect(property.entities.reject(&:marked_for_destruction?).size)
          .to eq(0)
        expect(property.agent).to_not be_nil
      end

    end

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

  describe 'search' do

    before :each do
      property_create!
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
