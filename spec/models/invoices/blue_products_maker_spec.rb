require 'rails_helper'

RSpec.describe BlueProductsMaker, type: :model do
  # Duplicate test
  describe '#invoice' do
    it 'can makes products' do
      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(charge: charge_new)]
      maker = BlueProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                    arrears: 0,
                                    transaction: transaction
      expect(maker.invoice.first.to_s)
        .to eq 'charge_type: Ground Rent ' \
               'date_due: 2013-03-25 ' \
               'amount: 88.08 ' \
               'period: 2013-03-25..2013-06-30, ' \
               'balance: '
    end

    it 'ignores products with automatic payments' do
      charge = charge_new payment_type: Charge::STANDING_ORDER
      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(charge: charge)]

      maker = BlueProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                    arrears: 0,
                                    transaction: transaction
      expect(maker.invoice.size).to eq 0
    end

    # Duplicate test
    context 'arrears creation' do
      it 'makes arrears from debts' do
        transaction = DebitsTransaction.new
        maker = BlueProductsMaker.new invoice_date: Date.new(1999, 1, 2),
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

        maker = BlueProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                      arrears: 0,
                                      transaction: transaction
        expect(maker.invoice.first.charge_type).to_not eq 'Arrears'
      end
    end
  end
  describe '#debits?' do
    it 'true if debits include charge with manual payment' do
      charge = charge_new payment_type: Charge::PAYMENT
      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(charge: charge)]

      maker = BlueProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                    arrears: 10,
                                    transaction: transaction

      expect(maker).to be_debits
    end

    it 'false if debits include charge with automatic payment' do
      charge = charge_new payment_type: Charge::STANDING_ORDER
      (transaction = DebitsTransaction.new)
        .debited debits: [debit_new(charge: charge)]

      maker = BlueProductsMaker.new invoice_date: Date.new(1999, 1, 2),
                                    arrears: 10,
                                    transaction: transaction

      expect(maker).to_not be_debits
    end
  end
end
