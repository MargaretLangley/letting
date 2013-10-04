require 'spec_helper'

describe Client do

  let(:client) { client_new  }
  it('is valid') { expect(client).to be_valid }

  context 'validations' do
    it '#human_id is present' do
      client.human_id = nil
      expect(client).not_to be_valid
    end

    it 'validates it is a number' do
      client.human_id = 'Not numbers'
      expect(client).to_not be_valid
    end

    it '#human_id is unique' do
      client.save!
      expect { Client.create! human_id: 1 }.to \
               raise_error ActiveRecord::RecordInvalid
    end

    it 'has at least one child' do
      client.entities.destroy_all
      expect(client).not_to be_valid
    end
  end

  context 'associations' do
    it('has entities')   { expect(client).to respond_to(:entities) }
    it('has address')    { expect(client).to respond_to :address }
    it('has properties') { expect(client).to respond_to(:properties) }
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
      expect(client.entities.reject(&:marked_for_destruction?)).to \
        have(0).items
    end
  end

  context 'search' do

    c1 = c2 = nil
    before { c1 = client_create! }

    it('human id') { expect((Client.search '8008').load).to eq [c1] }
    it('roads') { expect((Client.search 'Edg').load).to eq [c1] }
    it('towns') { expect((Client.search 'Bir').load).to eq [c1] }
    it('names') { expect(Client.search 'Grace').to eq [c1] }

    it 'only returns expected' do
      c2 = client_create! human_id: 102,
                          address_attributes: { road: 'unknown' }
      expect(Client.all).to eq [c1, c2]
      expect(Client.search 'Edgba').to eq [c1]
    end

    it 'ordered by human_id ASC' do
      c2 = client_create! human_id: 8000
      expect(Client.all).to eq [c1, c2]
      expect(Client.search 'Bir').to eq [c2, c1]
    end
  end
end
