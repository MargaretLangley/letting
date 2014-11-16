require 'rails_helper'
# rubocop: disable Metrics/LineLength
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe DebitMaker, type: :model do

  describe '#mold' do
    it 'produces debits for due charges' do
      chg = charge_create(cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)]))
      accnt = account_new charges: [chg],
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
      accnt = account_new charges: [chg],
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
      accnt = account_new charges: [chg],
                          debits: []

      make = DebitMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))

      make.mold
      expect(make.make?).to eq true
    end

    it 'not made is someone settled all debts (regardless of when paid)' do
      chg = charge_create amount: 40,
                          cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      accnt = account_new charges: [chg],
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
    it 'returns the transaction' do
      cycle = cycle_create(due_ons: [DueOn.new(month: 3, day: 5)])
      account = account_new charges: [charge_new(cycle: cycle)]
      debit_maker = DebitMaker.new account: account,
                                   debit_period: Date.new(2013, 3, 5)..
                                                 Date.new(2013, 5, 5)
      debit_maker.mold
      expect(debit_maker.invoice[:transaction].debits.size).to eq(1)
    end
  end
end
