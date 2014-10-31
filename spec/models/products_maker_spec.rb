require 'rails_helper'

RSpec.describe ProductsMaker, type: :model do
  it 'calculates invoice' do
    maker =
      ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                        arrears: 0,
                        debits: [debit_new(amount: 20, charge: charge_new)]
    expect(maker.invoice.size).to eq 1
  end

  it 'calculates the amount' do
    maker =
      ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                        arrears: 0,
                        debits: [debit_new(amount: 20, charge: charge_new)]

    expect(maker.invoice[:products].first.amount).to eq 20
  end

  describe 'balance' do
    it 'calculates the balance' do
      maker =
        ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                          arrears: 0,
                          debits: [debit_new(amount: 20, charge: charge_new)]

      expect(maker.invoice[:products].first.balance).to eq 20
    end

    it 'calculates the running balance' do
      maker =
        ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                          arrears: 0,
                          debits: [debit_new(amount: 20, charge: charge_new),
                                   debit_new(amount: 30, charge: charge_new)]

      expect(maker.invoice[:products].second.balance).to eq 50
    end

    it 'calculates the balance to include the arrears' do
      maker =
        ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                          arrears: 30,
                          debits: [debit_new(amount: 20, charge: charge_new)]

      expect(maker.invoice[:products].last.balance).to eq 50
    end
  end
end
