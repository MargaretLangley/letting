require 'rails_helper'

describe Charge, type: :model do

  describe 'validations' do
    before(:each) { charge_structure_create }

    it('is valid') { expect(charge_new).to be_valid }
    describe 'presence' do
      it('charge type') { expect(charge_new charge_type: nil).to_not be_valid }
      it('amount') { expect(charge_new amount: nil).to_not be_valid }
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
        charge.charge_structure_id = 1
        charge.clear_up_form
        expect(charge).to_not be_marked_for_destruction
      end
    end

    describe '#next_chargeable' do
      before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
      after(:each)  { Timecop.return }

      it 'bills if date range covers a due_on'  do
        charge_structure_create due_on_attributes: { day: 25, month: 3 }
        charge = charge_create
        chargeable = ChargeableInfo.from_charge(chargeable_attributes \
          charge_id: charge.id,
          on_date: Date.new(2013, 3, 25))
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2013, 3, 25)))
          .to eq [chargeable]
      end

      it 'does not bill if no charge is in date range' do
        charge_structure_create due_on_attributes: { day: 25, month: 3 }
        charge = charge_create
        expect(charge.next_chargeable(Date.new(2013, 2, 1)..\
                                      Date.new(2013, 3, 24)))
          .to eq []
      end

      # Would like to move this lower down within charging system
      it 'bills all due_ons within multi-year range - ONCE' do
        charge_structure_create due_on_attributes: { day: 25, month: 3 }
        charge = charge_create
        chargeable = ChargeableInfo.from_charge(chargeable_attributes \
          charge_id: charge.id,
          on_date: Date.new(2013, 3, 25))
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2016, 3, 25)))
          .to eq [chargeable]
      end

      it 'does not bill dormant charges'  do
        charge_structure_create due_on_attributes: { day: 25, month: 3 }
        charge = charge_create
        charge.dormant = true
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2013, 3, 25)))
          .to eq []
      end

      it 'ignores charges which have debits'  do
        charge_structure_create due_on_attributes: { day: 25, month: 3 }
        charge = charge_create
        charge.debits.build debit_attributes on_date: '2013-3-25'
        expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                      Date.new(2016, 3, 25)))
          .to eq []
      end
    end
  end

  # FIX_CHARGE
  it 'displays advanced date'
  it 'displays arrears date'
  it 'displays Midterm date'
end
