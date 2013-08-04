require 'spec_helper'

describe Client do

  let(:client) do
    client = Client.new human_client_id: 1
    client.entities.new person_entity_attributes
    client
  end

  it ('is valid') { expect(client).to be_valid }

  context 'validations' do
    it '#human_client_id is present' do
      client.human_client_id = nil
      expect(client).not_to be_valid
    end

    it 'validates it is a number' do
      client.human_client_id = "Not numbers"
      expect(client).to_not be_valid
    end

    it '#human_client_id is unique' do
      client.save!
      expect{ Client.create! human_client_id: 1 }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'has at least one child' do
      client.entities.destroy_all
      expect(client).not_to be_valid
    end
  end

  context 'Associations' do

    context '#entities' do
      it('is entitieable') { expect(client).to respond_to(:entities) }
    end

    context '#address' do

      let(:client) do
        client = Client.new human_client_id: 1
        client.entities.new person_entity_attributes
        client.build_address address_attributes road_no: 3456
        client
      end

      it('is addressable') { expect(client).to respond_to :address }

      it 'saving nil address does not change address count' do
        client.address = nil
        expect { client.save! }.to change(Address, :count).by 0
      end

      it 'is saved when filled in' do
        expect { client.save! }.to change(Address, :count).by 1
      end

    end

  end


end
