# rubocop: disable  Metrics/LineLength
require 'rails_helper'

RSpec.describe Invoice, type: :model do

  it('is valid') { expect(invoice_new).to be_valid }
  describe 'validates presence' do
    it('property_ref') do
      expect(invoice_new property: property_new(human_ref: nil)).to_not be_valid
    end
    it('invoice_date') { expect(invoice_new invoice_date: nil).to_not be_valid }
    it 'property_address' do
      (invoice = Invoice.new).property_address = nil
      expect(invoice).to_not be_valid
    end
  end

  describe 'when child invoices destroyed' do
    it 'destroys associated invoice_account if it has no surviving child invoices' do
      invoice_account, property = invoice_account_new, property_create
      invoice = invoice_create invoice_account: invoice_account,
                               property: property
      expect { invoice.destroy }.to change(InvoiceAccount, :count).by(-1)
    end
    it 'preserves associated invoice_account while account still has other'\
       'surviving child invoices' do
      invoice_account, property = invoice_account_new, property_create
      invoice_create invoice_account: invoice_account, property: property
      invoice = invoice_create invoice_account: invoice_account,
                               property: property
      expect { invoice.destroy }.to change(InvoiceAccount, :count).by(0)
    end
  end

  describe 'methods' do

    describe '#prepare' do
      it 'prepares invoice_date' do
        template_create id: 1
        property = property_create account: account_new, client: client_create
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   account: property.account,
                   property: property.invoice,
                   billing: { arrears: 0, transaction:  transaction }
        expect(invoice.invoice_date.to_s).to eq '2014-06-30'
      end

      it 'sets property_ref' do
        template_create id: 1
        invoice = Invoice.new
        property = property_create human_ref: 55, account: account_new
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        invoice.prepare account: property.account,
                        property: property.invoice,
                        billing: { arrears: 0, transaction:  transaction }
        expect(invoice.property_ref).to eq 55
      end

      it 'sets billing_address' do
        template_create id: 1
        invoice = Invoice.new
        agent = agent_new(entities: [Entity.new(name: 'Lock')])
        property = property_create agent: agent, account: account_new
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        invoice.prepare account: property.account,
                        property: property.invoice,
                        billing: { arrears: 0, transaction:  transaction }
        expect(invoice.billing_address)
          .to eq "Lock\nEdgbaston Road\nBirmingham\nWest Midlands"
      end

      it 'prepares invoice products' do
        template_create id: 1
        property = property_create account: account_new, client: client_create
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(charge: charge_new)])

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   account: property.account,
                   property: property.invoice,
                   billing: { arrears: 0, transaction:  transaction }
        expect(invoice.products.first.to_s)
          .to eq 'charge_type: Ground Rent date_due: 2013-03-25 amount: 88.08 '\
                 'period: 2013-03-25..2013-06-30'
      end

      it 'prepares invoice total_arrears' do
        template_create id: 1
        account = account_new(debits: [debit_new(amount: 40, charge: charge_new)])
        property = property_create account: account, client: client_create
        (transaction = InvoiceAccount.new)
          .debited(debits: [debit_new(amount: 10, charge: charge_new),
                            debit_new(amount: 20, charge: charge_new)])

        (invoice = Invoice.new)
          .prepare account: property.account,
                   invoice_date: '2014-06-30',
                   property: property.invoice,
                   billing: { transaction:  transaction }
        expect(invoice.total_arrears).to eq 70
        invoice.run_id = 5
        invoice.save!
      end

      describe 'arrears' do
        it 'debits increase total arrears' do
          account = account_new
          invoice_account = invoice_account_new debits: [debit_new(amount: 10, charge: charge_new)]
          invoice = invoice_create account: account, invoice_account: invoice_account
          expect(invoice.total_arrears).to eq 10
        end

        it 'credits decrease total arrears' do
          charge = charge_new
          account = account_new credits: [credit_new(amount: -30, charge: charge)]
          invoice_account = invoice_account_new debits: [debit_new(amount: 10, charge: charge)]
          invoice = invoice_create account: account, invoice_account: invoice_account
          expect(invoice.total_arrears).to eq(-20)
        end
      end
    end
    describe '#remake' do
      it 'invoice_date set to today' do
        invoice = invoice_create
        expect(invoice.remake.invoice_date).to eq Time.zone.today
      end

      it 'copies property ref' do
        invoice = invoice_create property: property_new(human_ref: 8)
        expect(invoice.remake.property_ref).to eq 8
      end

      it 'copies occupiers' do
        property = property_new(occupiers: [Entity.new(name: 'Prior')])
        invoice = invoice_create property: property
        expect(invoice.remake.occupiers).to eq 'Prior'
      end

      it 'sets property address' do
        property = property_new address: address_new(road: 'New Road')
        invoice = invoice_create property: property
        expect(invoice.remake.property_address)
          .to eq "New Road\nBirmingham\nWest Midlands"
      end

      it 'sets billing address' do
        property = property_new address: address_new(road: 'New Road')
        invoice = invoice_create property: property
        expect(invoice.remake.property_address)
          .to eq "New Road\nBirmingham\nWest Midlands"
      end

      it 'resets total_arrears if any payment is made' do
        invoice_account = invoice_account_new debits: [debit_new(amount: 10, charge: charge_new)]
        invoice = invoice_create account: account_new,
                                 invoice_account: invoice_account
        invoice.account.credits = [credit_new(amount: -2, charge: charge_new)]
        expect(invoice.remake.total_arrears).to eq 8
      end

      it 'resets product arrears if any payment is made' do
        invoice_account = invoice_account_new debits: [debit_new(amount: 10, charge: charge_new)]
        invoice = invoice_create account: account_new,
                                 invoice_account: invoice_account
        invoice.account.credits = [credit_new(amount: -2, charge: charge_new)]
        expect(invoice.remake.products.first.charge_type).to eq 'Arrears'
        expect(invoice.remake.products.first.amount).to eq(-2)
      end

    end

    describe '#back_page?' do
      it 'returns false if products have no ground rent' do
        debits = [debit_new(charge: charge_new(charge_type: 'Insurance'))]
        invoice = invoice_new invoice_account: invoice_account_new(debits: debits)
        expect(invoice.back_page?).to eq false
      end

      it 'returns true if products includes ground rent' do
        debits = [debit_new(charge: charge_new(charge_type: 'Ground Rent'))]
        invoice = invoice_new invoice_account: invoice_account_new(debits: debits)
        expect(invoice.back_page?).to eq true
      end
    end

    it 'outputs #to_s' do
      expect(invoice_new.to_s.lines.first)
      .to start_with %q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands")
    end
  end
end
