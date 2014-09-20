require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it('is valid') { expect(invoice_new).to be_valid }
  describe 'validates presence' do
    it('property_ref') { expect(invoice_new property_ref: nil).to_not be_valid }
    it('invoice_date') { expect(invoice_new invoice_date: nil).to_not be_valid }
    it 'property_address' do
      (invoice = Invoice.new).property_address = nil
      expect(invoice).to_not be_valid
    end
    it('arrears') { expect(invoice_new arrears: nil).to_not be_valid }
  end

  describe 'methods' do
    describe 'prepare' do
      it 'sets billing_address' do
        invoice = Invoice.new
        agent = agent_new(entities: [Entity.new(name: 'Lock')])
        property = property_new agent: agent, account: account_new
        invoice.prepare account: property.account
        expect(invoice.billing_address)
          .to eq "Lock\nEdgbaston Road\nBirmingham\nWest Midlands"
      end
      it 'sets property_ref' do
        invoice = Invoice.new
        property = property_new human_ref: 55, account: account_new
        invoice.prepare account: property.account
        expect(invoice.property_ref).to eq 55
      end
      it 'sets invoice_date' do
        invoice = Invoice.new
        property = property_new account: account_new
        invoice.prepare invoice_date: '2014-06-30', account: property.account
        expect(invoice.invoice_date.to_s).to eq '2014-06-30'
      end
      it 'sets property_address' do
        invoice = Invoice.new
        property = property_new address: address_new(road: 'New', town: 'Brum'),
                                account: account_new
        invoice.prepare account: property.account
        expect(invoice.property_address).to eq "New\nBrum\nWest Midlands"
      end
      it 'sets balance' do
        invoice = Invoice.new
        account = account_new credit: credit_new(amount: 17)
        property = property_new account: account
        expect(invoice.prepare(account: property.account).arrears).to eq(17.0)
      end
      it 'sets client' do
        invoice = Invoice.new
        account = account_new
        client_create entities: [Entity.new(name: 'Bell')],
                      property: property_new(account: account_new)
        expect(invoice.prepare(account: Account.first).client)
          .to eq "Bell\nEdgbaston Road\nBirmingham\nWest Midlands"
      end
    end
  end
end
