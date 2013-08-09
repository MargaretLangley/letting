require 'spec_helper'

describe Property do

  let(:property) do
    property = Property.new human_property_id: 8000
    property.entities.new person_entity_attributes
    property.build_billing_profile use_profile: false, property_id: property.id
    property
  end

  it ('#valid?') { expect(property).to be_valid }

  context 'validations' do
    context '#human_property_id' do

      it 'is present' do
        property.human_property_id = nil
        expect(property).not_to be_valid
      end

      it 'validates it is a number' do
        property.human_property_id = "Not numbers"
        expect(property).to_not be_valid
      end

      it 'validates it is unique' do
        property.save!
        property.id = nil # dirty way of saving it again
        expect { property.save! human_property_id: 8000 }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  context 'Associations' do

    context '#entities' do

      it('is entitieable') { expect(property).to respond_to(:entities) }

      it 'has at least one child' do
        property.entities.destroy_all
        expect(property).not_to be_valid
      end
    end

    context '#addresses' do
      it('is addressable') { expect(property).to respond_to :address }
    end

    it 'belongs to a client' do
      client = client_factory id: 1, human_client_id: 1
      property = client.properties.new human_property_id: 8000
      expect(property.client).to eq client
    end

  end

  context 'Methods' do

    context '#prepare_for_form' do
      let(:property) do
        property = Property.new human_property_id: 8000
        property.prepare_for_form
        property
      end

      it 'builds required models' do
        expect(property.address).to_not be_nil
        expect(property.entities).to have(2).items
        expect(property.billing_profile).to_not be_nil
      end

      it 'builds no more than the required models' do
        property.prepare_for_form  # * 2
        expect(property.address).to_not be_nil
        expect(property.entities).to have(2).items
        expect(property.billing_profile).to_not be_nil
      end


      it '#clear_up_after_form destroys unused models' do
        property.clear_up_after_form
        expect(property.address).to_not be_nil
        expect(property.entities.reject(&:marked_for_destruction?)).to have(0).items
        expect(property.billing_profile).to_not be_nil
      end
    end

    context '#bill_to' do

      it 'property with no billing profile' do
        expect(property.bill_to).to eq property
      end

      it 'billing profile when s' do
        property.build_billing_profile use_profile: true
        expect(property.bill_to).to eq property.billing_profile
      end

    end

    context '#separate_billing_address?' do
      it 'true when using billing profile' do
        property.separate_billing_address true
        expect(property.separate_billing_address?).to be_true
      end

      it 'false when not using billing profile' do
        property.separate_billing_address false
        expect(property.separate_billing_address?).to be_false
      end
    end
  end

  context 'search by house name' do

    p1 = p2 = p3 = c1 = nil

    before do
      p1 = property_factory human_property_id: 1,
            address_attributes: { house_name: 'Headingly', road: 'Kirstall Road', town: 'York' }
    end

    context 'search by house name' do
      it 'returns only those with that house name' do
        p2 = property_factory human_property_id: 2,
              address_attributes: { house_name: 'Headingly' }
        p3 = property_factory human_property_id: 3,
              address_attributes: { house_name: 'Vauxall Lane' }
        expect(Property.all).to eq [p1, p2, p3 ]
        expect(Property.search_by_house_name 'Headingly').to eq [p1, p2]
      end

      it 'does not return addresses from other types' do
        c1 = client_factory human_client_id: 1,
              address_attributes: { house_name: 'Headingly' }
        expect(Address.all.to_a).to eq [p1.address, c1.address]
        expect(Property.search_by_house_name 'Headingly').to eq [p1]
      end

      it 'it does not find part of the housename' do
        p4 = property_factory human_property_id: 2,
              address_attributes: { house_name: 'Lords' }
        expect(Address.all.to_a).to eq [p1.address, p4.address]
        expect(Property.search_by_house_name 'eadin').to eq []
      end
     end

     context 'like road or flat' do

      it 'returns matching road name' do
        p2 = property_factory human_property_id: 2,
              address_attributes: { house_name: 'Lords', road: 'Essex'}
        expect(Property.all).to eq [p1, p2]
        expect(Property.search_by_all 'Kirstall Road').to eq [p1]
      end

      it 'returns matching house names' do
        p2 = property_factory human_property_id: 3,
              address_attributes: { house_name: 'Vauxall Lane' }
        expect(Property.all).to eq [p1, p2]
        expect(Property.search_by_all 'Headingly').to eq [p1]
      end

      it 'returns matching road name' do
        p2 = property_factory human_property_id: 2,
              address_attributes: { house_name: 'Headingly', road: 'unknown' }
        expect(Property.all).to eq [p1, p2]
        expect(Property.search_by_all 'Kirstall').to eq [p1]
      end

      it 'returns matching towns' do
        p2 = property_factory human_property_id: 2,
              address_attributes: { town: 'unknown' }
        expect(Property.all).to eq [p1, p2]
        expect(Property.search_by_all 'York').to eq [p1]
      end

      it 'returns matching all works beginning with' do
        p2 = property_factory human_property_id: 2,
              address_attributes: { town: 'Yorks' }
        expect(Property.all).to eq [p1, p2]
        expect(Property.search_by_all 'York').to eq [p1,p2]
      end


     end

  end

end