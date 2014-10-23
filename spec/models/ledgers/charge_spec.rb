require 'rails_helper'

describe Charge, :ledgers, :range, type: :model do

  describe 'validations' do
    it('is valid') { expect(charge_new).to be_valid }
    describe 'presence' do
      it('charge type') { expect(charge_new charge_type: nil).to_not be_valid }
      it('amount') { expect(charge_new amount: nil).to_not be_valid }
      it('cycle') { expect(charge_new cycle: nil).to_not be_valid }
      it('charged_in') { expect(charge_new charged_in: nil).to_not be_valid }
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
        (charge = Charge.new).charged_in_id = 1
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
      expect(charge_new.to_s).to eq 'charge: Ground Rent, charged_in: Adv, '\
                                 'cycle: Mar, type: term, due_ons: [Mar 25]'
    end
  end
end
