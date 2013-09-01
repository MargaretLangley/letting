require 'spec_helper'

describe Property do

  let(:property) do
    property = Property.new human_id: 8000, client_id: 2
    property.entities.new person_entity_attributes
    property.build_billing_profile use_profile: false, property_id: property.id
    property
  end

  it ('#valid?') { expect(property).to be_valid }

  context 'validations' do
    context '#human_id' do

      it 'is present' do
        property.human_id = nil
        expect(property).not_to be_valid
      end

      it 'validates it is a number' do
        property.human_id = "Not numbers"
        expect(property).to_not be_valid
      end

      it 'validates it is unique' do
        property.save!
        property.id = nil # dirty way of saving it again
        expect { property.save! human_id: 8000 }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context '#client_id' do
      it 'required' do
        property.client_id = nil
        expect(property).not_to be_valid
      end

      it '#numeric' do
        property.client_id = 'Not numbers'
        expect(property).to_not be_valid
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
      client = client_factory id: 1, human_id: 1
      property = client.properties.new human_id: 8000
      expect(property.client).to eq client
    end

  end

  context 'Methods' do

    context '#prepare_for_form' do
      let(:property) do
        property = Property.new human_id: 8000
        property.prepare_for_form
        property
      end

      it 'builds required models' do
        expect(property.address).to_not be_nil
        expect(property.entities).to have(3).items
        expect(property.billing_profile).to_not be_nil
      end

      it 'builds no more than the required models' do
        property.prepare_for_form  # * 2
        expect(property.address).to_not be_nil
        expect(property.entities).to have(3).items
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
      let(:property) do
        property = Property.new human_id: 8000
        property.prepare_for_form
        property
      end

      it 'property with no billing profile' do
        expect(property.bill_to).to eq property
      end

      it 'billing profile when using it' do
        property.billing_profile.use_profile = true
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

  context 'search' do

    p1 = p2 = p3 = c1 = nil

    before do
      p1 = property_factory human_id: 1,
            address_attributes: { house_name: 'Headingly', road: 'Kirstall Road', town: 'York' },
            entities_attributes: { "0" =>  { name: 'Knutt', title: 'Rev', initials: 'K V' } }
    end

    context '#search_by_house_name' do
      it 'matches just that house name' do
        p2 = property_factory human_id: 2,
              address_attributes: { house_name: 'Headingly' }
        p3 = property_factory human_id: 3,
              address_attributes: { house_name: 'Vauxall Lane' }
        expect(Property.all).to eq [p1, p2, p3 ]
        expect(Property.search_by_house_name 'Headingly').to eq [p1, p2]
      end

      it 'returns property addreses only (and not client etc)' do
        c1 = client_factory human_id: 1,
              address_attributes: { house_name: 'Headingly' }
        expect(Address.all.to_a).to eq [p1.address, c1.address]
        expect(Property.search_by_house_name 'Headingly').to eq [p1]
      end

      it 'it does not find part of the housename' do
        p4 = property_factory human_id: 2,
              address_attributes: { house_name: 'Lords' }
        expect(Address.all.to_a).to eq [p1.address, p4.address]
        expect(Property.search_by_house_name 'eadin').to eq []
      end
     end

     context '#search' do

      it 'exact number (human_id)' do
        p2 = property_factory human_id: 10
        expect(Property.all).to eq [p1, p2]
        expect(Property.search '1').to eq [p1]
      end


      it 'exact names' do
        p2 = property_factory human_id: 2,
              address_attributes: { house_name: 'Lords', road: 'Essex'}
        expect(Property.all).to eq [p1, p2]
        expect(Property.search 'Kirstall Road').to eq [p1]
      end

      context 'wildcard' do
        it 'house name' do
          p2 = property_factory human_id: 3,
                address_attributes: { house_name: 'Vauxall Lane' }
          expect(Property.all).to eq [p1, p2]
          expect(Property.search 'Headi').to eq [p1]
        end
        it 'road name' do
          p2 = property_factory human_id: 2,
                address_attributes: { house_name: 'Headingly', road: 'unknown' }
          expect(Property.all).to eq [p1, p2]
          expect(Property.search 'Kirstall').to eq [p1]
        end
        it 'towns' do
          p2 = property_factory human_id: 2,
                address_attributes: { town: 'unknown' }
          expect(Property.all).to eq [p1, p2]
          expect(Property.search 'Yor').to eq [p1]
        end

        it 'multiple' do
          p2 = property_factory human_id: 2,
                address_attributes: { town: 'Yorks' }
          expect(Property.all).to eq [p1, p2]
          expect(Property.search 'Yor').to eq [p1,p2]
        end
      end

     end

  end

  context 'charges' do

    it 'has no charges' do
      expect(property.charges).to have_exactly(0).items
    end

    it 'has charges' do
      expect(property.charges).to eq []
    end

    # Tests that relationship exists
    it 'adds a new charge' do
      property.charges.build charge_type: 'ground_rent', \
        due_in: 'advance', amount: '50.50', property_id: property.id
      expect(property.charges.first.charge_type).to eq 'ground_rent'
    end

  end

end