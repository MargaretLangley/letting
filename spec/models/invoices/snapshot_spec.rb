require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  it 'requires debits' do
    snapshot = Snapshot.new
    expect(snapshot).not_to be_valid
  end

  it 'can be debited' do
    snapshot = Snapshot.new
    snapshot.debited debits: [debit_new(charge: charge_new)]
    expect(snapshot).to be_valid
  end

  it 'can sum' do
    snapshot = Snapshot.new
    snapshot
      .debited debits: [debit_new(amount: 10, charge: charge_new),
                        debit_new(amount: 20, charge: charge_new)]
    expect(snapshot.sum).to eq 30
  end

  describe '#debits?' do
    it 'knows if it has debits' do
      snapshot = Snapshot.new
      snapshot.debited debits: [debit_new(amount: 10, charge: charge_new)]
      expect(snapshot).to be_debits
    end

    it 'knows when it has no debits' do
      snapshot = Snapshot.new
      snapshot.debited debits: []
      expect(snapshot).to_not be_debits
    end
  end

  describe '#already_invoiced?' do
    it 'is not invoiced if empty' do
      snapshot = Snapshot.new
      snapshot.invoices = []
      expect(snapshot).to be_only_one_invoice
    end

    it 'is not invoiced if one invoice' do
      snapshot = Snapshot.new
      snapshot.invoices = [invoice_new]
      expect(snapshot).to be_only_one_invoice
    end

    it 'has been invoiced if more than one invoice' do
      snapshot = Snapshot.new
      snapshot.invoices = [invoice_new, invoice_new]
      expect(snapshot).to_not be_only_one_invoice
    end
  end
end
