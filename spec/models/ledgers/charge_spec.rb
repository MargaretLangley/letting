require 'rails_helper'

describe Charge, :ledgers, :range, type: :model do

  describe 'validations' do
    it('is valid') { expect(charge_new).to be_valid }
    describe 'presence' do
      it('charge type') { expect(charge_new charge_type: nil).to_not be_valid }
      it('amount') { expect(charge_new amount: nil).to_not be_valid }
      it('charge_cycle') do
        expect(charge_new charge_cycle: nil).to_not be_valid
      end
      it('charged_in') { expect(charge_new charged_in: nil).to_not be_valid }
    end
    describe 'amount' do
      it('is a number') { expect(charge_new amount: 'nn').to_not be_valid }
      it('has a max') { expect(charge_new amount: 100_000).to_not be_valid }
    end
  end

  describe 'methods' do
    describe '#clear_up_form' do
      it 'keeps charges by default' do
        expect(Charge.new).to_not be_marked_for_destruction
      end

      it 'clears new charges if asked' do
        charge = Charge.new
        charge.clear_up_form
        expect(charge).to be_marked_for_destruction
      end

      it 'keeps new charges if edited' do
        charge = Charge.new
        charge.charged_in_id = 1
        charge.clear_up_form
        expect(charge).to_not be_marked_for_destruction
      end
    end

    describe '#next_chargeable' do
      before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
      after(:each)  { Timecop.return }

      it 'bills if date range covers a due_on'  do
        charge = charge_create charge_cycle: \
                   charge_cycle_create(due_ons: [DueOn.new(day: 25, month: 3)])

        chargeable = ChargeableInfo.from_charge(chargeable_attributes \
          charge_id: charge.id,
          on_date: Date.new(2013, 3, 25))
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2013, 3, 25)))
          .to eq [chargeable]
      end

      it 'does not bill if no charge is in date range' do
        charge = charge_create charge_cycle: \
                   charge_cycle_create(due_ons: [DueOn.new(day: 25, month: 3)])
        expect(charge.next_chargeable(Date.new(2013, 2, 1)..\
                                      Date.new(2013, 3, 24)))
          .to eq []
      end

      # Would like to move this lower down within charging system
      it 'bills all due_ons within multi-year range - ONCE' do
        charge = charge_create charge_cycle: \
                   charge_cycle_create(due_ons: [DueOn.new(day: 25, month: 3)])
        chargeable = ChargeableInfo.from_charge(chargeable_attributes \
          charge_id: charge.id,
          on_date: Date.new(2013, 3, 25))
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2016, 3, 25)))
          .to eq [chargeable]
      end

      it 'does not bill dormant charges'  do
        charge = charge_create charge_cycle: \
                   charge_cycle_create(due_ons: [DueOn.new(day: 25, month: 3)])
        charge.dormant = true
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2013, 3, 25)))
          .to eq []
      end

      it 'ignores charges which have debits'  do
        charge = charge_create charge_cycle: \
                   charge_cycle_create(due_ons: [DueOn.new(day: 25, month: 3)])
        charge.debits.build debit_attributes on_date: '2013-3-25'
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2016, 3, 25)))
          .to eq []
      end
    end
  end

  it 'charge displays range' do
    skip 'FIX_CHARGE'
  end
end
