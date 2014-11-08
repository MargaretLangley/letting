require 'rails_helper'
# rubocop: disable Metrics/LineLength
# rubocop: disable Style/SpaceInsideRangeLiteral

RSpec.describe AccountsDebits, type: :model do

  # order by charge, property_ref
  # display contiguous numbers with '-'

  describe '#list' do
    it 'produces debits for due charges' do
      chg = charge_create amount: 80.08,
                          cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      account_create property: property_new(human_ref: 2), charges: [chg]

      debits = AccountsDebits.new(property_range: '2',
                                  debit_period: Date.new(2013, 3, 5)..
                                                Date.new(2013, 3, 5))
      debits.make_list
      expect(debits.list).to eq [Date.new(2013, 3, 5), 'Ground Rent'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 3, 5),
                                                   charge_type: 'Ground Rent',
                                                   property_ref: 2,
                                                   amount: nil)
    end

    it 'produces ordered account debits' do
      chg_1 = charge_create(charge_type: 'Ground Rent',
                            cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)]))
      chg_2 = charge_create(charge_type: 'Service Charge',
                            cycle: cycle_new(due_ons: [DueOn.new(month: 2, day: 5)]))
      chg_3 = charge_create(charge_type: 'Insurance',
                            cycle: cycle_new(due_ons: [DueOn.new(month: 8, day: 5)]))
      account_create property: property_new(human_ref: 2), charges: [chg_1, chg_2, chg_3]

      debits = AccountsDebits.new(property_range: '2',
                                  debit_period: Date.new(2013, 1, 1)..
                                                Date.new(2014, 1, 1))
      debits.make_list
      expect(debits.list).to eq [Date.new(2013, 2, 5), 'Service Charge'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 2, 5),
                                                   charge_type: 'Service Charge',
                                                   property_ref: 2,
                                                   amount: nil),
                                [Date.new(2013, 3, 5), 'Ground Rent'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 3, 5),
                                                   charge_type: 'Ground Rent',
                                                   property_ref: 2,
                                                   amount: nil),
                                [Date.new(2013, 8, 5), 'Insurance'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 8, 5),
                                                   charge_type: 'Insurance',
                                                   property_ref: 2,
                                                   amount: nil)
    end
  end
end
