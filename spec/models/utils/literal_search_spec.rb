require 'rails_helper'

describe LiteralSearch, type: :model do

  describe '#go' do
    describe 'client query' do
      it 'returns an exact client' do
        client = client_create human_ref: '8'
        expect(LiteralSearch.search(type: 'Client', query: '8').go[:record_id])
          .to eq client.id
      end

      it 'returns nil when no match' do
        expect(LiteralSearch.search(type: 'Client', query: '8').go[:record_id])
          .to be_nil
      end
    end

    describe 'cycle query' do
      it 'returns an exact cycle' do
        cycle = cycle_create name: 'Mar'
        expect(LiteralSearch.search(type: 'Cycle', query: 'Mar').go[:record_id])
          .to eq cycle.id
      end

      it 'return nil when no match' do
        expect(LiteralSearch.search(type: 'Cycle', query: 'Mar').go[:record_id])
          .to be_nil
      end
    end

    describe 'invoicing query' do
      it 'returns matching accounts' do
        ac_1 = account_create(property: property_new(human_ref: '100')).id
        ac_2 = account_create(property: property_new(human_ref: '200')).id
        expect(LiteralSearch.search(type: 'Invoicing', query: '100-200')
                            .go[:record_id])
          .to eq [ac_1, ac_2]
      end

      it 'returns empty when no match' do
        expect(LiteralSearch.search(type: 'Invoicing', query: '100-200')
                            .go[:record_id])
          .to eq []
      end
    end

    describe 'payment query' do
      it 'returns an exact account' do
        account = account_create property: property_new(human_ref: '100')
        expect(LiteralSearch.search(type: 'Payment', query: '100')
                            .go[:record_id])
          .to eq account.id
      end

      it 'returns nil when no match' do
        expect(LiteralSearch.search(type: 'Payment', query: '100')
                            .go[:record_id])
          .to be_nil
      end
    end

    describe 'property query' do
      it 'returns an exact property' do
        property = property_create human_ref: '100'
        expect(LiteralSearch.search(type: 'Property', query: '100')
                            .go[:record_id])
          .to eq property.id
      end

      it 'return nil when no match' do
        expect(LiteralSearch.search(type: 'Property', query: '100')
                            .go[:record_id])
          .to be_nil
      end
    end

    describe 'user query' do
      it 'returns an exact user' do
        user = user_create nickname: 'sam'
        expect(LiteralSearch.search(type: 'User', query: 'sam').go[:record_id])
          .to eq user.id
      end

      it 'return nil when no match' do
        expect(LiteralSearch.search(type: 'User', query: 'sam').go[:record_id])
          .to be_nil
      end
    end

    it 'errors on unknown type' do
      expect { LiteralSearch.search(type: 'X', query: 'y').go[:record_id] }
        .to raise_error NotImplementedError
    end
  end

  describe 'ordering' do
    it 'searches for the queried type before any other type' do
      property_create human_ref: '100'
      client = client_create human_ref: '100'
      expect(LiteralSearch.search(type: 'Client', query: '100').go[:record_id])
        .to eq client.id
    end

    it 'returns default if queried type does not have that value.' do
      property = property_create human_ref: '101'
      client_create human_ref: '100'
      expect(LiteralSearch.search(type: 'Client', query: '101').go[:record_id])
        .to eq property
    end
  end

end
