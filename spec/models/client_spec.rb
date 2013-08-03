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

    context '::contact' do

      context '#entities' do
        it 'has an array of entities' do
          expect(client).to respond_to(:entities)
        end
      end

      context '#address' do

        it 'returns address attributes' do
          client.build_address address_attributes road_no: 3456
          expect(client.address.road_no).to eq 3456
        end

        it 'is not saved if empty (rejected)' do
          client.address = nil
          expect { client.save! }.to change(Address, :count).by 0
        end

        it 'is saved when filled in' do
          client.build_address address_attributes
          expect { client.save! }.to change(Address, :count).by 1
        end

      end

    end
  end


end
