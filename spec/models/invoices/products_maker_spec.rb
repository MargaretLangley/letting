require 'rails_helper'

RSpec.describe ProductsMaker, type: :model do
  it 'calculates invoice' do
    (transaction = DebitsTransaction.new)
      .debited debits: [debit_new(amount: 20, charge: charge_new)]
    maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                              arrears: 0,
                              transaction: transaction
    expect(maker.invoice.size).to eq 1
  end

  it 'calculates the amount' do
    (transaction = DebitsTransaction.new)
      .debited debits: [debit_new(amount: 20, charge: charge_new)]

    maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                              arrears: 0,
                              transaction: transaction

    expect(maker.invoice.first.amount).to eq 20
  end
end
