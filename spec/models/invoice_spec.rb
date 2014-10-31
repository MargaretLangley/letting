# rubocop: disable  Metrics/LineLength
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
  end

  describe 'methods' do
    describe '#prepare' do
      it 'sets billing_address' do
        invoice = Invoice.new
        agent = agent_new(entities: [Entity.new(name: 'Lock')])
        property = property_new agent: agent, account: account_new
        invoice.property property.invoice
        expect(invoice.billing_address)
          .to eq "Lock\nEdgbaston Road\nBirmingham\nWest Midlands"
      end
      it 'sets property_ref' do
        invoice = Invoice.new
        property = property_new human_ref: 55, account: account_new
        invoice.property property.invoice
        expect(invoice.property_ref).to eq 55
      end
      it 'prepares invoice' do
        template_create id: 1
        property = property_new address: address_new(road: 'New', town: 'Brum'),
                                account: account_new
        client = client_create entities: [Entity.new(name: 'Bell')],
                               property: property_new(account: account_new)
        maker = ProductsMaker.new invoice_date: '2014-06-30',
                                  arrears: 0,
                                  debits: [debit_new(charge: charge_new)]

        (invoice = Invoice.new).prepare invoice_date: '2014-06-30',
                                        property: property.invoice,
                                        client: client.invoice,
                                        products: maker.invoice
        expect(invoice.invoice_date.to_s).to eq '2014-06-30'
      end

      it 'sets total_arrears' do
        (invoice = Invoice.new).total_arrears = 20
        expect(invoice.total_arrears).to eq(20)
      end
    end
    it 'outputs #to_s' do
      expect(invoice_new.to_s.lines.first)
      .to start_with %q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands")
    end
  end
end
