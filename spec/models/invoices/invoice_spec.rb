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
    it 'destroys associated debits_transaction if it has no surviving child invoices' do
      debits_transaction, property = debits_transaction_new, property_create
      invoice = invoice_create debits_transaction: debits_transaction,
                               property: property
      expect { invoice.destroy }.to change(DebitsTransaction, :count).by(-1)
    end
    it 'preserves associated debits_transaction while account still has other'\
       'surviving child invoices' do
      debits_transaction, property = debits_transaction_new, property_create
      invoice_create debits_transaction: debits_transaction, property: property
      invoice = invoice_create debits_transaction: debits_transaction,
                               property: property
      expect { invoice.destroy }.to change(DebitsTransaction, :count).by(0)
    end
  end

  describe 'methods' do

    describe '#prepare' do
      it 'prepares invoice_date' do
        template_create id: 1
        property = property_create account: account_new, client: client_create
        (transaction = DebitsTransaction.new)
          .debited(debits: [debit_new(charge: charge_new)])

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   account: property.account,
                   property: property.invoice,
                   debits_transaction: transaction
        expect(invoice.invoice_date.to_s).to eq '2014-06-30'
      end

      it 'sets property_ref' do
        template_create id: 1
        invoice = Invoice.new
        property = property_create human_ref: 55, account: account_new
        (transaction = DebitsTransaction.new)
          .debited(debits: [debit_new(charge: charge_new)])

        invoice.prepare account: property.account,
                        property: property.invoice,
                        debits_transaction: transaction
        expect(invoice.property_ref).to eq 55
      end

      it 'sets billing_address' do
        template_create id: 1
        invoice = Invoice.new
        agent = agent_new(entities: [Entity.new(name: 'Lock')])
        property = property_create agent: agent, account: account_new
        (transaction = DebitsTransaction.new)
          .debited(debits: [debit_new(charge: charge_new)])

        invoice.prepare account: property.account,
                        property: property.invoice,
                        debits_transaction: transaction
        expect(invoice.billing_address)
          .to eq "Lock\nEdgbaston Road\nBirmingham\nWest Midlands"
      end

      it 'prepares invoice products' do
        template_create id: 1
        property = property_create account: account_new, client: client_create
        (transaction = DebitsTransaction.new)
          .debited(debits: [debit_new(charge: charge_new)])

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   account: property.account,
                   property: property.invoice,
                   debits_transaction: transaction
        expect(invoice.products.first.to_s)
          .to eq 'charge_type: Ground Rent date_due: 2013-03-25 amount: 88.08 '\
                 'period: 2013-03-25..2013-06-30, balance: 88.08'
      end

      it 'finds the earliest due_date' do
        template_create id: 1
        property = property_create account: account_new, client: client_create
        (transaction = DebitsTransaction.new).debited debits:
          [debit_new(on_date: Date.new(2001, 1, 1), charge: charge_new),
           debit_new(on_date: Date.new(2000, 1, 1), charge: charge_new)]

        (invoice = Invoice.new)
          .prepare invoice_date: '2014-06-30',
                   account: property.account,
                   property: property.invoice,
                   debits_transaction: transaction
        expect(invoice.earliest_date_due).to eq Date.new(2000, 1, 1)
      end

      it 'prepares invoice total_arrears' do
        invoice = Invoice.new
        invoice.products = [product_new(amount: 10)]
        expect(invoice.total_arrears).to eq 10
      end

      describe 'comments' do
        it 'prepares without comments' do
          template_create id: 1
          property = property_create account: account_new, client: client_create
          (transaction = DebitsTransaction.new)
            .debited(debits: [debit_new(charge: charge_new)])

          (invoice = Invoice.new)
            .prepare account: property.account,
                     property: property.invoice,
                     debits_transaction: transaction
          expect(invoice.comments.size).to eq 0
        end

        it 'prepares with comments' do
          template_create id: 1
          property = property_create account: account_new, client: client_create
          (transaction = DebitsTransaction.new)
            .debited(debits: [debit_new(charge: charge_new)])

          (invoice = Invoice.new)
            .prepare account: property.account,
                     property: property.invoice,
                     debits_transaction: transaction,
                     comments: ['comment']
          expect(invoice.comments.size).to eq 1
          expect(invoice.comments.first.clarify).to eq 'comment'
        end

        it 'ignores empty comments' do
          template_create id: 1
          property = property_create account: account_new, client: client_create
          (transaction = DebitsTransaction.new)
            .debited(debits: [debit_new(charge: charge_new)])

          (invoice = Invoice.new)
            .prepare account: property.account,
                     property: property.invoice,
                     debits_transaction: transaction,
                     comments: ['comment', '']
          expect(invoice.comments.size).to eq 1
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
        debits_transaction = debits_transaction_new debits: [debit_new(amount: 10, charge: charge_new)]
        invoice = invoice_create account: account_new,
                                 debits_transaction: debits_transaction
        invoice.account.credits = [credit_new(amount: -2, charge: charge_new)]
        expect(invoice.remake.total_arrears).to eq 8
      end

      it 'resets product arrears if any payment is made' do
        debits_transaction = debits_transaction_new debits: [debit_new(amount: 10, charge: charge_new)]
        invoice = invoice_create account: account_new,
                                 debits_transaction: debits_transaction
        invoice.account.credits = [credit_new(amount: -2, charge: charge_new)]
        expect(invoice.remake.products.first.charge_type).to eq 'Arrears'
        expect(invoice.remake.products.first.amount).to eq(-2)
      end

    end

    describe '#back_page?' do
      it 'returns false if products have no ground rent' do
        debits = [debit_new(charge: charge_new(charge_type: 'Insurance'))]
        invoice = invoice_new debits_transaction: debits_transaction_new(debits: debits)
        expect(invoice.back_page?).to eq false
      end

      it 'returns true if products includes ground rent' do
        debits = [debit_new(charge: charge_new(charge_type: 'Ground Rent'))]
        invoice = invoice_new debits_transaction: debits_transaction_new(debits: debits)
        expect(invoice.back_page?).to eq true
      end
    end

    describe '#actionable?' do
      it 'returns true if in debt' do
        invoice = Invoice.new products: [product_new(amount: 30)]
        expect(invoice).to be_actionable
      end

      it 'returns false if not in debt' do
        invoice = Invoice.new products: [product_new(amount: 0)]
        expect(invoice).to_not be_actionable
      end
    end

    it 'outputs #to_s' do
      expect(invoice_new.to_s.lines.first)
      .to start_with %q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands")
    end
  end
end
