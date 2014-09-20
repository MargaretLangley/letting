require 'rails_helper'

describe 'Invoice Factory' do
  describe 'default' do
    it('is valid') { expect(invoice_new).to be_valid }
  end

  describe 'initializes from account' do
    it 'is valid' do
      expect(invoice_new).to be_valid
    end

    it 'sets invoice_date' do
      expect(invoice_new(invoice_date: '2014/07/31').invoice_date.to_s)
        .to eq '2014-07-31'
    end

    it 'sets property_ref' do
      expect(invoice_new(property_ref: 87).property_ref).to eq(87)
    end

    it 'sets property address' do
      address = address_new(road: 'New Road')
      expect(invoice_new(property_address: address).property_address)
        .to eq "New Road\nBirmingham\nWest Midlands"
    end

    it 'sets client' do
      client = \
      client_new entities: [Entity.new(name: 'Bell')],
                 address: address_new(road: 'New', town: 'Brum', county: 'West')
      expect(invoice_new(client: client.to_s).client)
        .to eq "Bell\nNew\nBrum\nWest"
    end
  end
end
