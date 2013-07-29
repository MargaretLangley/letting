require 'spec_helper'

describe BillingProfile do

  let(:billing_profile) { Property.new human_property_reference: 8000 }

  context '::contact' do

    context '#entities' do
      it 'has an array of entities' do
        expect(billing_profile.entities).to eq []
      end

      it "responds with its name after being created" do
        entity = billing_profile.entities.build name: "Mike"
        expect(entity.name).to eq 'Mike'
      end
    end

    context '#addresses' do
      it 'location returns an address' do
        billing_profile.build_address address_attributes road_no: 3456
        expect(billing_profile.address.road_no).to eq 3456
      end
    end

  end
end
