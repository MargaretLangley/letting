require 'rails_helper'

describe Client, type: :model do

  describe 'validations' do
    it('is valid') { expect(client_new).to be_valid }

    describe '#human_ref' do
      it('is needed') { expect(client_new(human_ref: nil)).to_not be_valid }
      it('is a number') { expect(client_new(human_ref: 'nan')).to_not be_valid }
      it 'is unique' do
        client_create human_ref: 1
        expect { client_create human_ref: 1 }
          .to raise_error ActiveRecord::RecordInvalid
      end
      it 'has a name' do
        (client = client_new).entities.destroy_all
        expect(client).to_not be_valid
      end
    end
  end

  describe 'method' do
    it 'returns invoice' do
      expect(client_new.invoice[:client])
        .to eq "Mr M. Prior\nEdgbaston Road\nBirmingham\nWest Midlands"
    end
    it 'returns client as text' do
      expect(client_new.to_s)
        .to eq "Mr M. Prior\nEdgbaston Road\nBirmingham\nWest Midlands"
    end
  end

  describe '#search', :search do
    before(:each) do
      client_create \
        human_ref: '8008',
        entities: [Entity.new(title: 'Mr', initials: 'I', name: 'Bell')],
        address: address_new(house_name: 'Hill', road: 'Edge', town: 'Birm')

      Client.import force: true, refresh: true
    end
    after(:each) { Client.__elasticsearch__.delete_index! }

    it('finds human_id') { expect(Client.search('8008').results.total).to eq 1 }
    it('finds names') { expect(Client.search('Bell').results.total).to eq 1 }
    it('finds houses') { expect(Client.search('Hil').results.total).to eq 1 }
    it('finds roads') { expect(Client.search('Edg').results.total).to eq 1 }
    it('finds towns') { expect(Client.search('Bir').results.total).to eq 1 }
  end
end
