require 'rails_helper'

# rubocop: disable Metrics/LineLength

describe Charge, :ledgers, :range, :cycle, type: :model do

  describe 'validations' do
    it('is valid') { expect(charge_new).to be_valid }
    describe 'presence' do
      it('charge type') { expect(charge_new charge_type: nil).to_not be_valid }
      it('amount') { expect(charge_new amount: nil).to_not be_valid }
      it('cycle') { expect(charge_new cycle: nil).to_not be_valid }
    end
    describe 'payment type' do
      it 'accepts string' do
        expect(charge_new payment_type: 'payment').to be_valid
      end
      it 'accepts const' do
        expect(charge_new payment_type: Charge::PAYMENT).to be_valid
      end
      it('rejects nil') { expect(charge_new payment_type: nil).to_not be_valid }
      it 'rejects unknown' do
        expect(charge_new payment_type: 'unknown').to_not be_valid
      end
      it 'rejects humanized' do
        expect(charge_new payment_type: 'Payment').to_not be_valid
      end
    end
    describe 'amount' do
      it('is a number') { expect(charge_new amount: 'nn').to_not be_valid }
      it('has a max') { expect(charge_new amount: 100_000).to_not be_valid }
    end
  end

  describe 'methods' do
    it('responds to monthly') { expect(charge_new).to_not be_monthly }

    describe '#clear_up_form' do
      it 'keeps charges by default' do
        expect(Charge.new).to_not be_marked_for_destruction
      end

      it 'clears new charges if asked' do
        (charge = Charge.new).clear_up_form
        expect(charge).to be_marked_for_destruction
      end

      it 'keeps new charges if edited' do
        (charge = Charge.new).charge_type = 'Rent'
        charge.clear_up_form
        expect(charge).to_not be_marked_for_destruction
      end
    end

    describe '#coming' do
      before(:each) { Timecop.travel Date.new(2013, 1, 31) }
      after(:each)  { Timecop.return }

      it 'charges if billing period crosses a due_on'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

        expect(ch.coming Date.new(2013, 3, 5)..Date.new(2013, 3, 5))
          .to eq [chargeable_new(charge_id: ch.id,
                                 on_date: Date.new(2013, 3, 5))]
      end

      it 'returns charges in date order - regardless of crossing year'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month:  3, day:  5),
                                                   DueOn.new(month: 12, day: 30)])

        expect(ch.coming Date.new(2010, 9, 5)..Date.new(2011, 9, 4))
          .to eq [chargeable_new(charge_id: ch.id,
                                 on_date: Date.new(2010, 12, 30)),
                  chargeable_new(charge_id: ch.id,
                                 on_date: Date.new(2011, 3, 5))]
      end

      it 'no charge if billing period misses all due_on' do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

        expect(ch.coming Date.new(2013, 2, 1)..Date.new(2013, 3, 4)).to eq []
      end

      it 'excludes dormant charges from billing'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
        ch.dormant = true
        expect(ch.coming Date.new(2013, 3, 5)..Date.new(2013, 3, 5)).to eq []
      end

      it 'anchors charges around billing period'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

        expect(ch.coming Date.new(2032, 3, 5)..Date.new(2032, 3, 5))
          .to eq [chargeable_new(charge_id: ch.id,
                                 on_date: Date.new(2032, 3, 5))]
      end
    end

    it '#to_s displays' do
      expect(charge_new.to_s)
        .to eq 'charge: Ground Rent, '\
               'cycle: Mar, type: term, charged_in: 2, due_ons: [Mar 25]'
    end
  end
end
