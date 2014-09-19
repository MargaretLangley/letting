require 'rails_helper'

describe 'Invoice Factory' do
  describe 'new' do
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

    it 'sets occupier' do
      property = property_new(occupiers: [Entity.new(name: 'Grace')])
      expect(invoice_new(property: property).occupier).to eq 'Grace'
    end

    it 'sets property address' do
      address = address_new(road: 'New Road')
      expect(invoice_new(property: property_new(address: address)).address)
        .to eq "New Road\nBirmingham\nWest Midlands"
    end

    it 'sets client name' do
      expect(invoice_new(client_name: 'M. Pi').client_name).to eq 'M. Pi'
    end

    it 'sets client address' do
      address = "New Road\nBrum\nWest Mids"
      expect(invoice_new(client_address: address).client_address)
        .to eq "New Road\nBrum\nWest Mids"
    end
  end
end
