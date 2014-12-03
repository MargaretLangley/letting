require 'rails_helper'
# rubocop: disable Metrics/LineLength
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe DebitTransactionMaker, type: :model do

  describe '#debits' do
    it 'produces debits for due charges' do
      chg = charge_create(cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)]))
      accnt = account_new charges: [chg],
                          debits: []

      make = DebitTransactionMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      expect(make).to be_debits
      expect(make.debits_transaction.debits)
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

      make = DebitTransactionMaker.new(account: accnt, debit_period: Date.new(2013, 3, 5)..
                                                          Date.new(2013, 3, 5))
      expect(make).to_not be_debits
    end
  end

  describe '#invoice' do
    it 'returns the transaction' do
      cycle = cycle_create(due_ons: [DueOn.new(month: 3, day: 5)])
      account = account_new charges: [charge_new(cycle: cycle)]
      make = DebitTransactionMaker.new account: account,
                                       debit_period: Date.new(2013, 3, 5)..
                                          Date.new(2013, 5, 5)
      expect(make.invoice.debits.size).to eq(1)
    end
  end
end
