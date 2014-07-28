require 'spec_helper'

describe Client, type: :model do

  let(:client) { client_new  }

  describe 'validations' do
    it('is valid') { expect(client).to be_valid }

    it '#human_ref is present' do
      client.human_ref = nil
      expect(client).to_not be_valid
    end

    it 'validates it is a number' do
      client.human_ref = 'Not numbers'
      expect(client).to_not be_valid
    end

    it '#human_ref is unique' do
      client_create! human_ref: 1
      expect {client_create! human_ref: 1}
        .to raise_error ActiveRecord::RecordInvalid
    end

    it 'has at least one child' do
      client.entities.destroy_all
      expect(client).to_not be_valid
    end
  end

  context '#prepare_for_form' do
    it 'builds entities' do
      client = Client.new
      expect(client.entities.size).to eq(0)
      client.prepare_for_form
      expect(client.entities.size).to eq(2)
    end

    it 'builds address' do
      client = Client.new
      expect(client.address).to be_nil
      client.prepare_for_form
      expect(client.address).to_not be_nil
    end

    it 'limits the number of prepared entities' do
      client = Client.new
      client.prepare_for_form
      client.prepare_for_form
      expect(client.entities.size).to eq(2)
    end

    it '#clear_up_form destroys unused models' do
      client = Client.new
      client.prepare_for_form
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

    describe '#search' do
      it('human id') { expect(Client.search('8008').results.total).to eq 1 }
      it('names') { expect(Client.search('Grac').results.total).to eq 1 }
      it('house') { expect(Client.search('Hil').results.total).to eq 1 }
      it('roads') { expect(Client.search('Edg').results.total).to eq 1 }
      it('towns') { expect(Client.search('Bir').results.total).to eq 1 }
    end
  end
end
