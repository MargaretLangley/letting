require 'rails_helper'

RSpec.describe ProductsMaker, type: :model do
  it 'calculates invoice' do
    (transaction = InvoiceAccount.new)
      .debited debits: [debit_new(amount: 20, charge: charge_new)]
    maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                              arrears: 0,
                              transaction: transaction
    expect(maker.invoice.size).to eq 1
  end

  it 'calculates the amount' do
    (transaction = InvoiceAccount.new)
      .debited debits: [debit_new(amount: 20, charge: charge_new)]

    maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                              arrears: 0,
                              transaction: transaction

    expect(maker.invoice[:products].first.amount).to eq 20
  end

  describe 'balance' do
    it 'calculates the balance' do

      (transaction = InvoiceAccount.new)
        .debited debits: [debit_new(amount: 20, charge: charge_new)]

      maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                arrears: 0,
                                transaction: transaction

      expect(maker.invoice[:products].first.balance).to eq 20
    end

    it 'calculates the running balance' do
      (transaction = InvoiceAccount.new)
        .debited debits: [debit_new(amount: 20, charge: charge_new),
                          debit_new(amount: 30, charge: charge_new)]

      maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                arrears: 0,
                                transaction: transaction

      expect(maker.invoice[:products].second.balance).to eq 50
    end

    it 'calculates the balance to include the arrears' do
      (transaction = InvoiceAccount.new)
        .debited debits: [debit_new(amount: 20, charge: charge_new)]

      maker =
        ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                          arrears: 30,
                          transaction: transaction

      expect(maker.invoice[:products].last.balance).to eq 50
    end
  end
end
