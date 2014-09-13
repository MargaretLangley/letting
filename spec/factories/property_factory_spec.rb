require 'rails_helper'

describe 'Property Factory' do

  describe 'new' do
    describe 'default' do
      it('is valid') { expect(property_new).to be_valid }
      it('has human_ref') { expect(property_new.human_ref).to eq 2002 }
    end

    describe 'overrides' do
      it('alters id') { expect(property_new(id: 2).id).to eq 2 }
      it 'alters human_ref' do
        expect(property_new(human_ref: 8).human_ref).to eq 8
      end
      it 'alters address' do
        property = property_new human_ref: 3001,
                                address_attributes: { road: 'Headingly Road' }
        expect(property.address.road).to eq 'Headingly Road'
      end
    end
    describe 'adds' do
      it 'can add account' do
        expect(property_new(account: account_new).account).to_not be_nil
      end

      it 'can add agent' do
        property = property_new agent: agent_new
        expect(property.agent.full_name).to eq 'Mr W. G. Grace'
      end

      it 'can add client' do
        property = property_new client: client_create(human_ref: 202)
        expect(property.client.human_ref).to eq 202
      end
    end
  end

  describe 'create' do
    describe 'default' do
      it('is created') { expect(property_create).to be_valid }
      it('has human_ref') { expect(property_create.human_ref).to eq 2002 }
    end

    describe 'overrides' do
      it 'alters human_ref' do
        expect(property_create(human_ref: 8).human_ref).to eq 8
      end
    end

    describe 'adds' do
      it 'can add account' do
        expect { property_create account: account_new }
          .to change(Account, :count).by(1)
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
