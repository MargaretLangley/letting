require 'rails_helper'

RSpec.describe ProductsMaker, type: :model do
  it 'makes products' do
    (transaction = DebitsTransaction.new)
      .debited debits: [debit_new(charge: charge_new)]
    maker = ProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                              arrears: 0,
                              transaction: transaction
    expect(maker.invoice.first.to_s)
      .to eq 'charge_type: Ground Rent ' \
             'date_due: 2013-03-25 ' \
             'amount: 88.08 ' \
             'period: 2013-03-25..2013-06-30, '\
             'balance: '
  end

  describe 'arrears creation' do
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
