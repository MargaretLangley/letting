require 'rails_helper'
# rubocop: disable Metrics/LineLength
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe InvoicingMaker, type: :model do

  describe '#do' do
    it 'produces debits if charge is due' do
      chg = charge_create(cycle: cycle_new(due_ons: [DueOn.new(day: 5, month: 3)]))
      accnt = account_new charge: chg,
                          debits: []

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      expect(make.mold).to eq [Debit.new(account_id: 2,
                                         charge_id: chg.id,
                                         on_date: Date.new(2013, 3, 5),
                                         period_first: Date.new(2013, 3, 5),
                                         period_last: Date.new(2014, 3, 4),
                                         amount: 88.08)]
    end

    it 'rejects duplicate charges' do
      chg = charge_create cycle: cycle_new(due_ons: [DueOn.new(day: 5, month: 3)])
      accnt = account_new charge: chg,
                          debits: [debit_new(on_date: '2013-3-5', charge: chg)]

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      expect(make.mold).to eq []
    end
  end

  describe '#make_debits?' do
    it 'produces debits if charge is due' do
      chg = charge_create(cycle: cycle_new(due_ons: [DueOn.new(day: 5, month: 3)]))
      accnt = account_new charge: chg,
                          debits: []

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      expect(make).to be_make_debits
    end

    it 'rejects duplicate charges' do
      chg = charge_create cycle: cycle_new(due_ons: [DueOn.new(day: 5, month: 3)])
      accnt = account_new charge: chg,
                          debits: [debit_new(on_date: '2013-3-5', charge: chg)]

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      expect(make).not_to be_make_debits
    end
  end

  describe '#sum' do
    it 'produces debits if charge is due' do
      chg = charge_create(amount: 20.00,
                          cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5),
                                                     DueOn.new(month: 3, day: 6)]))
      accnt = account_new charge: chg,
                          debits: []

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 6))
      expect(make.sum).to eq 40.00
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

      it 'subtracts credits before billing period' do
        credit = credit_new amount: -30, on_date: Date.new(2013, 3, 4)
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

    describe 'total_arrears' do
      it 'adds debits before billing period' do
        debit = debit_new amount: 30, on_date: Date.new(2013, 3, 4)
        account = account_new debits: [debit]
        debit_maker = DebitMaker.new account: account,
                                     debit_period: Date.new(2013, 3, 5)..
                                                   Date.new(2013, 5, 5)
        expect(debit_maker.invoice[:total_arrears]).to eq(30)
      end

      it 'adds debits during the billing period' do
        account = account_new charge: charge_new(amount: 43, cycle: \
          cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        debit_maker = DebitMaker.new account: account,
                                     debit_period: Date.new(2013, 3, 5)..
                                                   Date.new(2013, 5, 5)
        expect(debit_maker.invoice[:total_arrears]).to eq(43)
      end

      it 'totals debits before and during billing period' do
        account = account_new \
          debits: [debit_new(amount: 30, on_date: Date.new(2013, 3, 4))],
          charge: charge_new(amount: 43, cycle: \
            cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        debit_maker = DebitMaker.new account: account,
                                     debit_period: Date.new(2013, 3, 5)..
                                                   Date.new(2013, 5, 5)
        expect(debit_maker.invoice[:total_arrears]).to eq(73)
      end
    end

    it 'produces debits if charge is due' do
      account = account_new charge: charge_new(cycle: \
        cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
      debit_maker = DebitMaker.new account: account,
                                   debit_period: Date.new(2013, 3, 5)..
                                                 Date.new(2013, 5, 5)
      expect(debit_maker.invoice[:debits].size).to eq(1)
    end

    it 'no debits when charge is not due' do
      account = account_new charge: charge_new(cycle: \
        cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
      debit_maker = DebitMaker.new account: account,
                                   debit_period: Date.new(2013, 3, 6)..
                                                 Date.new(2013, 5, 6)
      expect(debit_maker.invoice[:debits].size).to eq(0)
    end
  end
end
