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
    describe 'presence' do
      it 'agent' do
        (property = property_new).agent = nil
        expect(property).to_not be_valid
      end
      it 'entities' do
        expect(property_new occupiers: []).to_not be_valid
      end
    end
  end

  describe 'Methods' do
    describe '#invoice' do
      describe '[:billing_address]' do
        context 'without agent' do
          property = nil
          before do
            agent = agent_new authorized: false,
                              entities: [Entity.new(name: 'Bel')],
                              address: address_new(road: 'Old', town: 'York')
            property = property_new occupiers: [Entity.new(name: 'Grace')],
                                    address: address_new(road: 'N', town: 'Bm'),
                                    agent: agent
          end
          it 'displays property text' do
            expect(property.invoice[:billing_address])
              .to eq "Grace\nN\nBm\nWest Midlands"
          end
        end
        context 'with agent' do
          property = nil
          before do
            agent = agent_new authorized: true,
                              entities: [Entity.new(name: 'Bel')],
                              address: address_new(road: 'Old', town: 'York')
            property = property_new occupiers: [Entity.new(name: 'Grace')],
                                    address: address_new(road: 'N', town: 'Bm'),
                                    agent: agent
          end
          it 'displays property text' do
            expect(property.invoice[:billing_address])
              .to eq "Bel\nOld\nYork\nWest Midlands"
          end
        end
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
      it 'human id' do
        expect(Property.search('2002', sort: 'human_ref').results.total).to eq 1
      end
      it 'names'  do
        expect(Property.search('Grac', sort: 'human_ref').count).to eq 1
      end
      it 'house'  do
        expect(Property.search('Hil', sort: 'human_ref').count).to eq 1
      end
      it 'roads'  do
        expect(Property.search('Edg', sort: 'human_ref').count).to eq 1
      end
      it 'towns'  do
        expect(Property.search('Bir', sort: 'human_ref').count).to eq 1
      end
    end
  end
end
