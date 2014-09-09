require 'rails_helper'

describe LiteralSearch, type: :model do

  describe '#go' do
    it 'return nil when no match' do
      expect(LiteralSearch.search(type: 'Property', query: '100')
                          .go[:record_id])
        .to eq nil
    end

    it 'return an exact property ref' do
      property = property_create human_ref: '100'
      expect(LiteralSearch.search(type: 'Property', query: '100')
                          .go[:record_id])
        .to eq property.id
    end

    it 'return an exact client ref' do
      client = client_create human_ref: '101'
      expect(LiteralSearch.search(type: 'Client', query: '101').go[:record_id])
        .to eq client.id
    end

    it 'return an exact user' do
      user = user_create nickname: 'george'
      expect(LiteralSearch.search(type: 'User', query: 'george').go[:record_id])
        .to eq user.id
    end

    it 'return an exact charge cycle' do
      cycle = charge_cycle_create name: 'Mar/Sep'
      expect(LiteralSearch.search(type: 'ChargeCycle', query: 'Mar/Sep')
                          .go[:record_id])
        .to eq cycle.id
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
