require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe InvoiceRemaker, type: :model do
  describe '#compose' do
    it 'makes a new invoice' do
      remaker = InvoiceRemaker.new invoice_text: invoice_new,
                                   invoice_date: Date.new(2001, 1, 1),
                                   products: []
      expect(remaker.compose.to_s)
        .to eq [%q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands"),
                %q(Property Ref: 2002),
                %q(Invoice Date: Mon, 01 Jan 2001),
                %q(Property Address: "Edgbaston Road\nBirmingham\nWest Midlands"),
                %q(client: "")].join "\n"

      # %q - act as single quote  \n => \\n
      # %Q - act as double quote  \n =  \n
    end

    it 'invoice_date set to today' do
      remaker = InvoiceRemaker.new invoice_text: invoice_new,
                                   invoice_date: Date.new(2001, 1, 1),
                                   products: []
      expect(remaker.compose.invoice_date).to eq Date.new(2001, 1, 1)
    end

    it 'copies property ref' do
      invoice = invoice_new property: property_new(human_ref: 8)
      remaker = InvoiceRemaker.new invoice_text: invoice,
                                   products: []
      expect(remaker.compose.property_ref).to eq 8
    end

    it 'copies occupiers' do
      property = property_new(occupiers: [Entity.new(name: 'Prior')])
      invoice = invoice_new account: account_new, property: property

      remaker = InvoiceRemaker.new invoice_text: invoice,
                                   products: []

      expect(remaker.compose.occupiers).to eq 'Prior'
    end

    it 'sets property address' do
      property = property_new address: address_new(road: 'New Road')
      invoice = invoice_new property: property

      remaker = InvoiceRemaker.new invoice_text: invoice,
                                   products: []

      expect(remaker.compose.property_address)
        .to eq "New Road\nBirmingham\nWest Midlands"
    end

    it 'sets billing_address' do
      property =
        property_create agent: agent_new(entities: [Entity.new(name: 'Lock')])
      invoice = invoice_new account: account_new, property: property

      remaker = InvoiceRemaker.new invoice_text: invoice,
                                   products: []

      expect(remaker.compose.billing_address)
        .to eq "Lock\nEdgbaston Road\nBirmingham\nWest Midlands"
    end
  end
end
