require 'rails_helper'

describe Charge, :ledgers, :range, type: :model do

  describe 'validations' do
    it('is valid') { expect(charge_new).to be_valid }
    describe 'presence' do
      it('charge type') { expect(charge_new charge_type: nil).to_not be_valid }
      it('amount') { expect(charge_new amount: nil).to_not be_valid }
      it('cycle') do
        expect(charge_new cycle: nil).to_not be_valid
      end
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

      it 'charges if billing period includes a due_on'  do
        charge = charge_new \
                   cycle: cycle_new(due_ons: [DueOn.new(day: 25, month: 3)])

        expect(charge.coming Date.new(2013, 3, 25)..Date.new(2013, 3, 25))
          .to eq [chargeable_new(charge_id: charge.id,
                                 on_date: Date.new(2013, 3, 25))]
      end

      it 'no charge if billing period excludes all due_on' do
        charge = charge_new \
                   cycle: cycle_new(due_ons: [DueOn.new(day: 25, month: 3)])
        expect(charge.coming Date.new(2013, 2, 1)..Date.new(2013, 3, 24))
          .to eq []
      end

      it 'excludes dormant charges from billing'  do
        charge = charge_new \
                   cycle: cycle_new(due_ons: [DueOn.new(day: 25, month: 3)])
        charge.dormant = true
        expect(charge.coming Date.new(2013, 3, 25)..Date.new(2013, 3, 25))
          .to eq []
      end

      it 'anchors charges around billing period'  do
        charge = charge_new \
                   cycle: cycle_new(due_ons: [DueOn.new(day: 25, month: 3)])

        expect(charge.coming Date.new(2032, 3, 25)..Date.new(2032, 3, 25))
          .to eq [chargeable_new(charge_id: charge.id,
                                 on_date: Date.new(2032, 3, 25))]
      end
    end

    it '#to_s displays' do
      expect(charge_new.to_s).to eq 'charge: Ground Rent, charged_in: Adv, '\
                                 'cycle: Mar/Sep, type: term, due_ons: [Mar 25]'
    end
  end
end
