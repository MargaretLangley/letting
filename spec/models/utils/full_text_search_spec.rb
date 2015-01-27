require 'rails_helper'

describe FullTextSearch, type: :model do
  describe '#go', :search do
    it 'return default when mismatch' do
      property_create address: address_new(road: 'Edge')
      Property.import force: true, refresh: true

      results = FullTextSearch.search(type: 'Property', query: 'Batt').go
      expect(results[:records].count).to eq 0
      expect(results[:render]).to eq 'properties/index'
      Property.__elasticsearch__.delete_index!
    end

    it 'return property when refeerer property' do
      property_create address: address_new(road: 'Edge')
      Property.import force: true, refresh: true

      results = FullTextSearch.search(type: 'Property', query: 'Edg').go
      expect(results[:records].first.class).to eq Property
      expect(results[:render]).to eq 'properties/index'
      Property.__elasticsearch__.delete_index!
    end

    it 'return client when refeerer client' do
      client_create human_ref: 30
      Client.import force: true, refresh: true

      results = FullTextSearch.search(type: 'Client', query: '30').go
      expect(results[:records].first.class).to eq Client
      expect(results[:render]).to eq 'clients/index'
      Client.__elasticsearch__.delete_index!
    end

    it 'returns payment' do
      property_create human_ref: 9,
                      account: account_new(payment: payment_new(amount: 40.35))
      Payment.import force: true, refresh: true

      results = FullTextSearch.search(type: 'Payment', query: '40.35').go
      expect(results[:records].first.class).to eq Payment
      expect(results[:records].first.amount).to eq 40.35
      expect(results[:render]).to eq 'payments/add_new_payment_index'
      Payment.__elasticsearch__.delete_index!
    end
  end
end
