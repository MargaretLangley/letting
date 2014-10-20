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
      expect(make.do).to eq [Debit.new(account_id: 2,
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
      expect(make.do).to eq []
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
end
