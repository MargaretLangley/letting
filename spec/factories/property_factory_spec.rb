require 'rails_helper'

describe 'Property Factory' do

  describe 'new' do
    describe 'default' do
      it('has human_ref') { expect(property_new.human_ref).to eq 2002 }
    end

    describe 'overrides' do
      it('id') { expect(property_new(id: 2).id).to eq 2 }
      it('human_ref') { expect(property_new(human_ref: 8).human_ref).to eq 8 }

      it 'address' do
        property = property_new human_ref: 3001,
                                address_attributes: { road: 'Headingly Road' }
        expect(property.address.road).to eq 'Headingly Road'
      end
    end
    describe 'adding' do
      it 'can add agent' do
        property = property_new agent: agent_new
        expect(property.agent.full_name).to eq 'Mr W. G. Grace'
      end

      it 'can add charge' do
        property = property_new(account: account_new(charge: charge_new))
        expect(property.account.charges[0].charge_type).to eq 'Ground Rent'
      end

      it 'can add client' do
        property = property_new client: client_create(human_ref: 202)
        expect(property.client.human_ref).to eq 202
      end
    end
  end

  describe 'create' do
    it('valid') { expect(property_create).to be_valid }

    describe 'default' do
      it('has human_ref') { expect(property_create.human_ref).to eq 2002 }
    end

    describe 'overrides' do
      it 'human_ref' do
        expect(property_create(human_ref: 8).human_ref).to eq 8
      end
    end

    describe 'adding' do
      it 'can add charge' do
        property_create(account: account_new(charge: charge_new))
        expect(Property.first.account.charges[0].charge_type)
          .to eq 'Ground Rent'
      end

      it 'can add agent' do
        property_create agent: agent_new
        expect(Property.first.agent.entities.full_name).to eq 'Mr W. G. Grace'
      end

      it 'can add client' do
        property_create client: client_create(human_ref: 202)
        expect(Property.first.client.human_ref).to eq 202
      end
    end
  end
end
