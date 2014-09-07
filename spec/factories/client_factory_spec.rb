require 'rails_helper'

describe 'Client Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(client_new).to be_valid }
      it('no id') { expect(client_new.id).to eq nil }
      it('has human_ref') { expect(client_new.human_ref).to eq 8008 }
      it('has entity') { expect(client_new.entities[0].name).to eq 'Grace' }
      it('has address') { expect(client_new.address.town).to eq 'Birmingham' }
    end
    describe 'overrides' do
      it 'alters human_ref' do
        expect(client_new(human_ref: 3).human_ref).to eq 3
      end
      it 'alters address' do
        client = client_create address_attributes: { town: 'York' }
        expect(client.address.town).to eq 'York'
      end
    end
  end
end
