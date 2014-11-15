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
        template_create id: 1
        invoice = Invoice.new
        agent = agent_new(entities: [Entity.new(name: 'Lock')])
        property = property_new agent: agent, account: account_new
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        invoice.prepare property: property.invoice,
                        billing: { arrears: 0, transaction:  transaction }
        expect(invoice.billing_address)
          .to eq "Lock\nEdgbaston Road\nBirmingham\nWest Midlands"
      end
      it 'sets property_ref' do
        template_create id: 1
        invoice = Invoice.new
        property = property_new human_ref: 55, account: account_new
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        invoice.prepare property: property.invoice,
                        billing: { arrears: 0, transaction:  transaction }
        expect(invoice.property_ref).to eq 55
      end

      it 'prepares invoice_date' do
        template_create id: 1
        property = property_new account: account_new, client: client_create
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   property: property.invoice,
                   billing: { arrears: 0, transaction:  transaction }
        expect(invoice.invoice_date.to_s).to eq '2014-06-30'
      end

      it 'prepares invoice products' do
        template_create id: 1
        property = property_new account: account_new, client: client_create
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   property: property.invoice,
                   billing: { arrears: 0, transaction:  transaction }
        expect(invoice.products.first.to_s)
          .to eq 'charge_type: Ground Rent date_due: 2013-03-25 amount: 88.08 '\
                 'period: 2013-03-25..2013-06-30'
      end

      it 'prepares invoice total_arreras' do
        template_create id: 1
        property = property_new account: account_new, client: client_create
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(amount: 10, charge: charge_new),
                            debit_new(amount: 20, charge: charge_new)])

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   property: property.invoice,
                   billing: { arrears: 40, transaction:  transaction }
        expect(invoice.total_arrears).to eq 70
        invoice.run_id = 5
        invoice.save!
      end
    end
    it 'outputs #to_s' do
      expect(invoice_new.to_s.lines.first)
      .to start_with %q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands")
    end
  end
end
