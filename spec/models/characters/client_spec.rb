require 'spec_helper'

describe Client, type: :model do

  let(:client) { client_new  }
  it('is valid') { expect(client).to be_valid }

  context 'validations' do
    it '#human_ref is present' do
      client.human_ref = nil
      expect(client).to_not be_valid
    end

    it 'validates it is a number' do
      client.human_ref = 'Not numbers'
      expect(client).to_not be_valid
    end

    it '#human_ref is unique' do
      client.save!
      expect { Client.create! human_ref: 1 }
        .to raise_error ActiveRecord::RecordInvalid
    end

    it 'has at least one child' do
      client.entities.destroy_all
      expect(client).to_not be_valid
    end
  end

  context '#prepare_for_form' do
    let(:client) do
      client = Client.new human_ref: 8000
      client.prepare_for_form
      client
    end

    it 'builds required models' do
      expect(client.address).to_not be_nil
      expect(client.entities.size).to eq(2)
    end

    it 'builds no more than the required models' do
      client.prepare_for_form  # * 2
      expect(client.address).to_not be_nil
      expect(client.entities.size).to eq(2)
    end

    it '#clear_up_form destroys unused models' do
      client.clear_up_form
      expect(client.address).to_not be_nil
      expect(client.entities.reject(&:marked_for_destruction?).size)
        .to eq(0)
    end
  end

  describe 'search' do

    before :each do
      client_create!
      Client.import force: true, refresh: true
    end

    after :each do
      Client.__elasticsearch__.delete_index!
    end

    context '#search' do
      it('human id') { expect(Client.search('8008').results.total).to eq 1 }
      it('names') { expect(Client.search('Grac').results.total).to eq 1 }
      it('house') { expect(Client.search('Hil').results.total).to eq 1 }
      it('roads') { expect(Client.search('Edg').results.total).to eq 1 }
      it('towns') { expect(Client.search('Bir').results.total).to eq 1 }
    end
  end
end
