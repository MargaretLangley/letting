require 'spec_helper'

describe Property do

  let(:property) { property_new }
  it('is valid') { expect(property).to be_valid }

  context 'validations' do
    context 'human_ref' do

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

    context 'client_id' do
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

  context 'Methods' do

    context '#prepare_for_form' do
      let(:property) do
        property = Property.new human_ref: 8000
        property.prepare_for_form
        property
      end

      it 'builds required models' do
        expect(property.address).to_not be_nil
        expect(property.entities).to have(2).items
        expect(property.agent).to_not be_nil
      end

      it 'builds no more than the required models' do
        property.prepare_for_form  # * 2
        expect(property.address).to_not be_nil
        expect(property.entities).to have(2).items
        expect(property.agent).to_not be_nil
      end

      it '#clear_up_form destroys unused models' do
        property.clear_up_form
        expect(property.address).to_not be_nil
        expect(property.entities.reject(&:marked_for_destruction?))
          .to have(0).items
        expect(property.agent).to_not be_nil
      end

    end

    context '#bill_to' do
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

  context 'search' do

    p1 = p2 = nil
    before { p1 = property_create! }

    context '#search_by_house_name' do

      it 'matches just that house name' do
        p2 = property_create! human_ref: 202,
                              address_attributes: { house_name: 'Headingly' }
        expect(Property.all).to match_array [p1, p2]
        expect(Property.sql_search_by_house_name('Hillbank House').load)
          .to eq [p1]
      end

      it 'no wildcard matching' do
        expect(Property.sql_search_by_house_name 'illbank').to eq []
      end

    end

    context '#search' do

      it('human id') { expect((Property.sql_search '2002').load).to eq [p1] }
      it 'range of human_ref' do
        p2 = property_create! human_ref: 2003
        p3 = property_create! human_ref: 2004
        expect(Property.all).to match_array [p1, p2, p3]
        expect(Property.sql_search '2002 - 2003').to eq [p1, p2]
      end
      it('house name') { expect((Property.sql_search 'Hill').load).to eq [p1] }
      it('roads') { expect((Property.sql_search 'Edg').load).to eq [p1] }
      it('towns') { expect((Property.sql_search 'Bir').load).to eq [p1] }
      it('names') { expect(Property.sql_search 'Grace').to eq [p1] }
      it 'multiple' do
        p2 = property_create! human_ref: 3000
        expect(Property.all).to match_array [p1, p2]
        expect(Property.sql_search 'Bir').to eq [p1, p2]
      end
      it 'ordered by human_ref ASC' do
        p2 = property_create! human_ref: 2000
        expect(Property.all).to match_array [p1, p2]
        expect(Property.sql_search 'Bir').to eq [p2, p1]
      end

    end
  end
end
