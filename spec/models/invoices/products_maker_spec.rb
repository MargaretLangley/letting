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

  describe 'product arrears' do
    it 'makes arrears from debts' do
      (transaction = DebitsTransaction.new)

      maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                arrears: 10,
                                transaction: transaction

      expect(maker.invoice.first.charge_type).to eq 'Arrears'
      expect(maker.invoice.first.to_s)
        .to eq 'charge_type: Arrears date_due: 1999-01-02 amount: 10.0 '\
               'period: .., balance: '
    end

    it 'No arrears unless outstanding debt' do
      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(charge: charge_new)]

      maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                arrears: 0,
                                transaction: transaction
      expect(maker.invoice.first.charge_type).to_not eq 'Arrears'
    end
  end
end
