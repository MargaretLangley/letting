require 'rails_helper'

describe Property, type: :model do
  it('is valid') { expect(property_new).to be_valid }

  describe 'validations' do
    describe '#human_ref' do
      it('is present') { expect(property_new(human_ref: nil)).to_not be_valid }
      it('is a number') { expect(property_new(human_ref: 'n')).to_not be_valid }
      it 'is unique' do
        property_create human_ref: 8000
        expect { property_create human_ref: 8000 }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'Methods' do
    describe '#bill_to' do
      it 'invoices the property without an agent' do
        property = property_new
        expect(property.bill_to).to eq property
      end

      it 'invoices agent when available' do
        (property = property_new).agent.authorized = true
        expect(property.bill_to).to eq property.agent
      end
    end
  end

  describe 'search', :search do
    before :each do
      property_create address: address_new(house_name: 'Hill')
      Property.import force: true, refresh: true
    end

    after(:each) { Property.__elasticsearch__.delete_index! }

    describe '.search' do
      it('human id') { expect(Property.search('2002').results.total).to eq 1 }
      it('names') { expect(Property.search('Grac').results.total).to eq 1 }
      it('house') { expect(Property.search('Hil').results.total).to eq 1 }
      it('roads') { expect(Property.search('Edg').results.total).to eq 1 }
      it('towns') { expect(Property.search('Bir').results.total).to eq 1 }
    end
  end
end
