require 'rails_helper'

describe LiteralSearch, type: :model do
  describe '#go' do
    describe 'client query' do
      it 'returns an exact client' do
        client = client_create human_ref: '8'
        referrer = Referrer.new controller: 'clients', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '8').go.id)
          .to eq client.id
      end

      it 'returns nil when no match' do
        referrer = Referrer.new controller: 'clients', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '8').go.id)
          .to be_nil
      end
    end

    describe 'payment query' do
      it 'returns an exact account' do
        account = account_create property: property_new(human_ref: '100')
        referrer = Referrer.new controller: 'payments', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '100').go.id)
          .to eq account.id
      end

      it 'returns nil when no match' do
        referrer = Referrer.new controller: 'payments', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '100').go.id)
          .to be_nil
      end
    end

    describe 'property query' do
      it 'returns an exact property' do
        property = property_create human_ref: '100'
        referrer = Referrer.new controller: 'properties', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '100').go.id)
          .to eq property.id
      end

      it 'return nil when no match' do
        referrer = Referrer.new controller: 'properties', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '100').go.id)
          .to be_nil
      end
    end

    it 'errors on unknown type' do
      referrer = Referrer.new controller: 'X', action: ''

      expect { LiteralSearch.search(referrer: referrer, query: 'y').go.id }
        .to raise_error NotImplementedError
    end
  end

  describe 'ordering' do
    it 'searches for the queried type before any other type' do
      property_create human_ref: '100'
      client = client_create human_ref: '100'
      referrer = Referrer.new controller: 'clients', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '100').go.id)
        .to eq client.id
    end

    it 'returns default if queried type does not have that value.' do
      client_create human_ref: '100'
      not_a_client = property_create human_ref: '101'
      referrer = Referrer.new controller: 'clients', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '101').go.id)
        .to eq not_a_client.id
    end
  end
end
