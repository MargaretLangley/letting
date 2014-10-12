require 'rails_helper'

RSpec.describe Invoicing, type: :model do
  it('is valid') { expect(invoicing_new).to be_valid }
  describe 'validates presence' do
    it 'property_range' do
      expect(invoicing_new property_range: nil).to_not be_valid
    end
    it('start_date') { expect(invoicing_new start_date: nil).to_not be_valid }
    it('end_date') { expect(invoicing_new end_date: nil).to_not be_valid }
    it('invoices') { expect(invoicing_new invoices: nil).to_not be_valid }
  end

  describe '#invoiceable?' do
    it 'returns true when invoiceable' do
      expect(Invoicing.new.invoiceable? accounts: [account_new])
        .to be true
    end

    it 'returns true when invoiceable using full stack' do
      Timecop.travel Date.new(2014, 6, 1)
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
      account_create charge: charge_new(charge_cycle: cycle),
                     property: property_new(human_ref: 100)
      invoicing = invoicing_new property_range: '100',
                                start_date: '2014-06-22', end_date: '2014-06-30'
      expect(invoicing.invoiceable?).to be true
      Timecop.return
    end

    it 'returns false when not invoiceable' do
      expect(Invoicing.new.invoiceable? accounts: []).to be false
    end

    it 'returns false when not invoiceable using full stack' do
      Timecop.travel Date.new(2014, 6, 1)
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
      account_create charge: charge_new(charge_cycle: cycle),
                     property: property_new(human_ref: 100)
      invoicing = invoicing_new property_range: '100',
                                start_date: '2014-06-22', end_date: '2014-06-24'
      expect(invoicing.invoiceable?).to be false
      Timecop.return
    end
  end

  describe '#invoiceable_accounts' do
    before { Timecop.travel Date.new(2014, 6, 1) }
    after { Timecop.return }
    it 'returns accounts to invoice' do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
      account = account_create charge: charge_new(charge_cycle: cycle)
      invoicing = invoicing_new start_date: '2014-06-22', end_date: '2014-06-30'

      expect(invoicing.invoiceable_accounts accounts: [account])
        .to eq [account]
    end

    it 'does not invoice accounts without a debit' do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
      account = account_create charge: charge_new(charge_cycle: cycle)
      invoicing = invoicing_new start_date: '2014-06-22', end_date: '2014-06-24'

      expect(invoicing.invoiceable_accounts accounts: [account]).to eq []
    end
  end

  describe '#make_properties_range' do
    it 'creates a range' do
      ac1 = account_create property: property_new(human_ref: 5)
      ac2 = account_create property: property_new(human_ref: 6)
      ac3 = account_create property: property_new(human_ref: 7)
      expect(Invoicing.new.make_properties_range [ac1, ac2, ac3]).to eq '5 - 7'
    end
  end

  describe '#make_invoice' do
    it 'calls invoice_prepare' do
      invoice = Invoice.new
      account = account_new
      debit = debit_new(charge: charge_new)
      expect(invoice).to receive(:prepare).with account: account,
                                                debits: [debit]
      invoicing_new.make_invoice invoice: invoice,
                                 account: account,
                                 debits: [debit]
    end

    it 'calls prepare_products' do
      invoice = Invoice.new
      debit = debit_new
      account = account_create charge: charge_new(debits: [debit]),
                               property: property_new
      expect(invoice).to receive(:prepare_products).with debits: [debit]
      invoicing_new.make_invoice invoice: invoice,
                                 account: account,
                                 debits: [debit]
    end
  end
end
