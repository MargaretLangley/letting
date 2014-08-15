require 'rails_helper'

describe DueOns, type: :model do

  let(:charge) do
    ChargeStructure.new charge_cycle_id: 1, charged_in_id: 1
  end
  let(:due_ons) { charge.due_ons }

  context 'validates' do
    context 'due_ons_size' do
      it 'invalid above max' do
        (1..13).each { charge.due_ons.build day: 25, month: 3 }
        expect(charge).to_not be_valid
      end
      it 'valid if marked for destruction' do
        charge.charged_in = charged_in_create
        charge.charge_cycle = charge_cycle_create
        (1..13).each { charge.due_ons.build day: 25, month: 3 }
        charge.due_ons.first.mark_for_destruction
        expect(charge).to be_valid
      end
    end
  end

  context 'methods' do

    context '#due_dates' do
      before { Timecop.travel Date.new 2013, 4, 1 }
      after { Timecop.return }

      it 'returns date when range in due date' do
        due_ons.build day: 4, month: 4
        due_ons.build day: 3, month: 5
        expect(due_ons.due_dates date_range_covering_due_on)
          .to eq [Date.new(2013, 4, 4), Date.new(2013, 5, 3)]
      end

      it 'returns nils when range outside due date' do
        due_ons.build day: 1, month: 2
        expect(due_ons.due_dates date_range_missing_due_on)
          .to be_empty
      end
    end

    context '#prepare' do
      it 'fills empty' do
        expect(due_ons.size).to eq(0)
        due_ons.prepare
        expect(due_ons.size).to eq(4)
      end
    end

    context '#clears_up_form' do
      it 'leaves valid or partially filled due_ons' do
        due_ons.build due_on_attributes_0
        due_ons.build
        due_ons.clear_up_form
        expect(due_ons.reject { |due_on| due_on.marked_for_destruction? }.size)
                      .to eq(1)
      end
    end

    context '#empty?' do
      it 'is empty when nothing in it' do
        expect(due_ons).to be_empty
      end

      it 'not empty when something in it' do
        due_ons.build due_on_attributes_0
        expect(due_ons).to_not be_empty
      end
    end

    context '#monthly?' do
      context 'by number' do
        it '12 persistable due_ons monthly charge' do
          (1..12).each { due_ons.build day: 1, month: 1 }
          expect(due_ons).to be_monthly
        end

        it '< 12 persistable due_ons not monthly' do
          (1..11).each { due_ons.build day: 1, month: 1 }
          due_ons.build
          expect(due_ons).to_not be_monthly
        end
      end
      context 'by per_month due_on' do
        it 'is not per month without it' do
          due_ons.build day: 1, month: -1
          expect(due_ons).to be_monthly
        end
      end

      context '#new?' do
        it 'true with new persistable record' do
          due_ons.build due_on_attributes_0
          expect(due_ons).to be_new
        end

        it 'false with new empty record' do
          due_ons.build
          expect(due_ons).to_not be_new
        end
      end
    end

    context 'creating, saving and loading', broken: true do

      it 'new on date' do
        charge_structure = ChargeStructure.new charge_cycle_id: 1, \
                                               charged_in_id: 1
        charge_structure.prepare
        charge_structure.due_ons.build day: 24, month: 6
        charge_structure.due_ons.build day: 25, month: 12
        charge_structure.clear_up_form
        charge_structure.save!
        reload = ChargeStructure.find(charge_structure.id)
        expect(reload.due_ons.size).to eq(2)
      end

      it 'on date to different on date' do
        charge_structure = ChargeStructure.new charge_cycle_id: 1,
                                               charged_in_id: 1
        charge_structure.due_ons.build day: 24, month: 6, id: 7
        charge_structure.due_ons.build day: 25, month: 12, id: 8
        charge_structure.due_ons.prepare
        charge_structure.clear_up_form
        charge_structure.save!
        load = ChargeStructure.find(charge_structure.id)
        load.due_ons.prepare
        load.due_ons[0].update day: 5, month: 1
        load.due_ons[1].update day: '', month: ''
        load.clear_up_form
        load.save!
        reloaded = Charge.find(charge_structure.id)
        expect(reloaded.due_ons.size).to eq(1)
      end

      it 'new per date' do
        charge_structure = ChargeStructure.new charge_cycle_id: 1,
                                               charged_in_id: 1
        charge_structure.due_ons.prepare
        charge_structure.due_ons.build day: 5, month: -1
        charge_structure.clear_up_form
        charge_structure.save!
        load = ChargeStructure.find(charge_structure.id)
        expect(load.due_ons.size).to eq(12)
      end

      it 'per month to different per month' do
        charge_per_date = Charge.new charge_attributes account_id: 1
        charge_per_date.prepare
        charge_per_date.due_ons.build day: 24, month: -1
        charge_per_date.clear_up_form
        charge_per_date.save!
        charge_diff_date = Charge.find(charge_per_date.id)
        charge_diff_date.prepare
        charge_diff_date.due_ons.build day: 10, month: -1
        charge_diff_date.clear_up_form
        charge_diff_date.save!
        charge_reload = Charge.find(charge_per_date.id)
        expect(charge_reload.due_ons.size).to eq(12)
      end

      it 'per month to same per month' do
        charge = Charge.new charge_attributes account_id: 1
        charge.prepare
        charge.due_ons.build day: 24, month: -1
        charge.clear_up_form
        charge.save!
        reload = Charge.find(charge.id)
        reload.prepare
        reload.due_ons.build day: 24, month: -1
        reload.clear_up_form
        reload.save!
        reload2 = Charge.find(charge.id)
        reload2.prepare
        expect(reload2.due_ons.size).to eq(12)
      end

      it 'on date to per month' do
        charge = Charge.new charge_attributes account_id: 1
        charge.due_ons.build day: 24, month: 6
        charge.due_ons.build day: 25, month: 12
        charge.prepare
        charge.clear_up_form
        charge.save!
        reload = Charge.find(charge.id)
        reload.prepare
        reload.due_ons.build day: 10, month: -1
        reload.clear_up_form
        reload.save!
        reload2 = Charge.find(charge.id)
        expect(reload2.due_ons.size).to eq(12)
      end

      it 'per month to on date' do
        charge = Charge.new charge_attributes account_id: 1
        charge.prepare
        charge.due_ons.build day: 24, month: -1
        charge.clear_up_form
        charge.save!
        reload = Charge.find(charge.id)
        reload.prepare
        reload.due_ons.build day: 1, month: 5
        reload.due_ons.build day: 1, month: 11
        reload.clear_up_form
        reload.save!
        reload2 = Charge.find(charge.id)
        expect(reload2.due_ons.size).to eq(2)
      end

      it 'what happens if per_month day same as on date day' do
        'Edge case that I should consider'
      end
    end
  end

  def date_range_covering_due_on
    Date.new(2013, 4, 4) .. Date.new(2013, 5, 5)
  end

  def date_range_missing_due_on
    Date.new(2013, 4, 4) .. Date.new(2013, 5, 2)
  end
end
