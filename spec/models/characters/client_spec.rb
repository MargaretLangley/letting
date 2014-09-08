require 'rails_helper'

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
      client_create human_ref: 1
      expect { client_create human_ref: 1 }
        .to raise_error ActiveRecord::RecordInvalid
    end

    it 'has at least one child' do
      client.entities.destroy_all
      expect(client).to_not be_valid
    end
  end

  describe '#search', :search do
    before(:each) do
      client_create human_ref: '8008'
      Client.import force: true, refresh: true
    end
    after(:each) { Client.__elasticsearch__.delete_index! }

    it('human id') { expect(Client.search('8008').results.total).to eq 1 }
    it('names') { expect(Client.search('Grac').results.total).to eq 1 }
    it('house') { expect(Client.search('Hil').results.total).to eq 1 }
    it('roads') { expect(Client.search('Edg').results.total).to eq 1 }
    it('towns') { expect(Client.search('Bir').results.total).to eq 1 }
  end
end
