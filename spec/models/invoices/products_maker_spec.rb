require 'rails_helper'

RSpec.describe ProductsMaker, type: :model do
  it 'calculates invoice' do
    (transaction = DebitsTransaction.new)
      .debited debits: [debit_new(amount: 20, charge: charge_new)]
    maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                              arrears: 0,
                              transaction: transaction
    expect(maker.invoice[:products].size).to eq 1
  end

  it 'calculates the amount' do
    (transaction = DebitsTransaction.new)
      .debited debits: [debit_new(amount: 20, charge: charge_new)]

    maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                              arrears: 0,
                              transaction: transaction

    expect(maker.invoice[:products].first.amount).to eq 20
  end

  describe 'total_arrears' do
    it 'calculates the balance' do

      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(amount: 20, charge: charge_new)]

      maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                arrears: 0,
                                transaction: transaction

      expect(maker.invoice[:total_arrears]).to eq 20
    end

    it 'sums the balance' do
      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(amount: 20, charge: charge_new),
                          debit_new(amount: 30, charge: charge_new)]

      maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                arrears: 0,
                                transaction: transaction

      expect(maker.invoice[:total_arrears]).to eq 50
    end

    it 'balance includes any current arrears' do
      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(amount: 20, charge: charge_new)]

      maker =
        ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                          arrears: 30,
                          transaction: transaction

      expect(maker.invoice[:total_arrears]).to eq 50
    end
  end
end
