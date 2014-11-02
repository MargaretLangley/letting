require 'rails_helper'
# rubocop: disable Metrics/LineLength
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe DebitMaker, type: :model do

  describe '#mold' do
    it 'produces debits for due charges' do
      chg = charge_create(cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)]))
      accnt = account_new charge: chg,
                          debits: []

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      make.mold
      expect(make.invoice_account.debits)
        .to eq [Debit.new(account_id: 2,
                          charge_id: chg.id,
                          on_date: Date.new(2013, 3, 5),
                          period_first: Date.new(2013, 3, 5),
                          period_last: Date.new(2014, 3, 4),
                          amount: 88.08)]
    end

    it 'reject duplicate charges' do
      chg = charge_create cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      accnt = account_new charge: chg,
                          debits: [debit_new(on_date: '2013-3-5', charge: chg)]

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      make.mold
      expect(make.invoice_account.debits).to eq []
    end
  end

  describe '#make?' do
    it 'made if charge is due' do
      chg = charge_create cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      accnt = account_new charge: chg,
                          debits: []

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))

      make.mold
      expect(make.make?).to eq true
    end

    it 'reject is someone has paid (regardless of when paid)' do
      chg = charge_create amount: 40,
                          cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      accnt = account_new charge: chg,
                          credits: [credit_new(amount: -40,
                                               charge: chg,
                                               on_date: Date.new(2013, 4, 6))]

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      make.mold
      expect(make.make?).to eq false
    end
  end

  describe '#invoice' do
    describe 'arrears' do
      it 'adds debits before billing period' do
        debit = debit_new amount: 30, on_date: Date.new(2013, 3, 4)
        account = account_new debits: [debit]
        debit_maker = DebitMaker.new account: account,
                                     debit_period: Date.new(2013, 3, 5)..
                                                   Date.new(2013, 5, 5)
        expect(debit_maker.invoice[:arrears]).to eq(30)
      end

      it 'subtracts credits regardless of when paid' do
        credit = credit_new amount: -30, on_date: Date.new(2013, 9, 9)
        account = account_new credits: [credit]
        debit_maker = DebitMaker.new account: account,
                                     debit_period: Date.new(2013, 3, 5)..
                                                   Date.new(2013, 5, 5)
        expect(debit_maker.invoice[:arrears]).to eq(-30)
      end

      it 'smoke test' do
        debit_1 = debit_new amount: 10, on_date: Date.new(2012, 3, 4)
        debit_2 = debit_new amount: 10, on_date: Date.new(2013, 3, 4)
        credit_1 = credit_new amount: -30, on_date: Date.new(2012, 3, 4)
        credit_2 = credit_new amount: -30, on_date: Date.new(2013, 3, 4)
        account = account_new credits: [credit_1, credit_2],
                              debits: [debit_1, debit_2]

        debit_maker = DebitMaker.new account: account,
                                     debit_period: Date.new(2013, 3, 5)..
                                                   Date.new(2013, 5, 5)
        expect(debit_maker.invoice[:arrears]).to eq(-40)
      end
    end

    it 'returns the transaction' do
      account = account_new charge: charge_new(cycle: \
        cycle_create(due_ons: [DueOn.new(month: 3, day: 5)]))
      debit_maker = DebitMaker.new account: account,
                                   debit_period: Date.new(2013, 3, 5)..
                                                 Date.new(2013, 5, 5)
      debit_maker.mold
      expect(debit_maker.invoice[:transaction].debits.size).to eq(1)
    end
  end
end
