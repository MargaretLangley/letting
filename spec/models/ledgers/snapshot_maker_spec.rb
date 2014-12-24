require 'rails_helper'

RSpec.describe SnapshotMaker, type: :model do
  describe '#debits' do
    it 'produces debits for due charges' do
      chg = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      accnt = account_new charges: [chg],
                          debits: []

      make = SnapshotMaker.new account: accnt, debit_period: '2013/03/05'..
                                                             '2013/03/05'
      expect(make).to be_debits
      expect(make.snapshot.debits).to eq [Debit.new(account_id: 2,
                                                    charge_id: chg.id,
                                                    on_date: '2013/03/05',
                                                    period_first: '2013/03/05',
                                                    period_last: '2014/03/04',
                                                    amount: 88.08)]
    end

    it 'reject duplicate charges' do
      chg = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      acct = account_new charges: [chg],
                         debits: [debit_new(on_date: '2013/03/05', charge: chg)]

      make = SnapshotMaker.new account: acct, debit_period: '2013/03/05'..
                                                            '2013/03/05'
      expect(make).to_not be_debits
    end
  end

  describe '#invoice' do
    it 'returns the snapshot' do
      cycle = cycle_create(due_ons: [DueOn.new(month: 3, day: 5)])
      account = account_new charges: [charge_new(cycle: cycle)]
      make = SnapshotMaker.new account: account,
                               debit_period: '2013/03/05'..'2013/05/05'

      expect(make.invoice.debits.size).to eq(1)
    end
  end
end
