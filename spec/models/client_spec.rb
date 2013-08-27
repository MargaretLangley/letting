require 'spec_helper'

describe Client do

  let(:client) do
    client = Client.new human_id: 1
    client.entities.new person_entity_attributes
    client
  end

  it ('is valid') { expect(client).to be_valid }

  context 'validations' do
    it '#human_id is present' do
      client.human_id = nil
      expect(client).not_to be_valid
    end

    it 'validates it is a number' do
      client.human_id = "Not numbers"
      expect(client).to_not be_valid
    end

    it '#human_id is unique' do
      client.save!
      expect{ Client.create! human_id: 1 }.to raise_error ActiveRecord::RecordInvalid
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
        client = Client.new human_id: 1
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

    context '#properties' do
      it('has properties') { expect(client).to respond_to(:properties) }
    end
  end

  context '#prepare_for_form' do
    let(:client) do
      client = Client.new human_id: 8000
      client.prepare_for_form
      client
    end

    it 'builds required models' do
      expect(client.address).to_not be_nil
      expect(client.entities).to have(2).items
    end

    it 'builds no more than the required models' do
      client.prepare_for_form  # * 2
      expect(client.address).to_not be_nil
      expect(client.entities).to have(2).items
    end


    it '#clear_up_after_form destroys unused models' do
      client.clear_up_after_form
      expect(client.address).to_not be_nil
      expect(client.entities.reject(&:marked_for_destruction?)).to have(0).items
    end
  end

  context 'search' do

   c3 = c2 = c1 = nil

    before do
        c1 = client_factory human_id: 111,
              address_attributes: { house_name: 'Headingly', road: 'Kirstall Road', town: 'York' },
              entity_attributes: { name: 'Pieman', title: 'Ms', initials: 'YK' }
    end

    it 'exact number (human_id)' do
      c2 = client_factory human_id: 131
      expect(Client.all).to eq [c1, c2]
      expect(Client.search '111').to eq [c1]
    end

    it 'towns' do
       c2 = client_factory human_id: 131,
            address_attributes: { town: 'unknown' }
      expect(Client.all).to eq [c1, c2]
      expect(Client.search 'Yor').to eq [c1]
    end


    it 'entities names' do
      c2 = client_factory human_id: 102,
            address_attributes: { house_name: 'Headingly', road: 'unknown' },
            entities_attributes: { name: 'Gormless', title: 'Mr', initials: 'BJ' }
      expect(Client.all).to eq [c1, c2]
      expect(Client.search 'Gormless').to eq [c2]
    end

    it 'road name' do
      c2 = client_factory human_id: 102,
            address_attributes: { house_name: 'Headingly', road: 'unknown' }
      expect(Client.all).to eq [c1, c2]
      expect(Client.search 'Kirstall').to eq [c1]
    end

    it 'multiple' do
      c2 = client_factory human_id: 102,
            address_attributes: { town: 'Yorks' }
      expect(Client.all).to eq [c1, c2]
      expect(Client.search 'Yor').to eq [c1,c2]
    end

  end
end
