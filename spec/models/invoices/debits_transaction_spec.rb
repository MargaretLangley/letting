require 'rails_helper'

RSpec.describe DebitsTransaction, type: :model do
  it 'requires debits' do
    debits_transaction = DebitsTransaction.new
    expect(debits_transaction).not_to be_valid
  end

  it 'can be debited' do
    debits_transaction = DebitsTransaction.new
    debits_transaction.debited debits: [debit_new(charge: charge_new)]
    expect(debits_transaction).to be_valid
  end

  it 'can sum' do
    debits_transaction = DebitsTransaction.new
    debits_transaction
      .debited debits: [debit_new(amount: 10, charge: charge_new),
                        debit_new(amount: 20, charge: charge_new)]
    expect(debits_transaction.sum).to eq 30
  end

  describe '#debits?' do
    it 'knows if it has debits' do
      transaction = DebitsTransaction.new
      transaction.debited debits: [debit_new(amount: 10, charge: charge_new)]
      expect(transaction).to be_debits
    end

    it 'knows when it has no debits' do
      transaction = DebitsTransaction.new
      transaction.debited debits: []
      expect(transaction).to_not be_debits
    end
  end

  describe '#already_invoiced?' do
    it 'is not invoiced if empty' do
      transaction = DebitsTransaction.new
      transaction.invoices = []
      expect(transaction).to be_only_one_invoice
    end

    it 'is not invoiced if one invoice' do
      transaction = DebitsTransaction.new
      transaction.invoices = [invoice_new]
      expect(transaction).to be_only_one_invoice
    end

    it 'has been invoiced if more than one invoice' do
      transaction = DebitsTransaction.new
      transaction.invoices = [invoice_new, invoice_new]
      expect(transaction).to_not be_only_one_invoice
    end
  end
end
