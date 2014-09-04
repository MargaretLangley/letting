require 'rails_helper'

describe DueOns, :ledgers, type: :model do

  let(:cycle) { ChargeCycle.new id: 1, name: 'Anything', order: 1 }
  let(:due_ons) { cycle.due_ons }

  context 'validates' do
    context 'due_ons_size' do
      it 'invalid above max' do
        (1..13).each { cycle.due_ons.build day: 25, month: 3 }
        expect(cycle).to_not be_valid
      end
      it 'valid if marked for destruction' do
        (1..13).each { cycle.due_ons.build day: 25, month: 3 }
        cycle.due_ons.first.mark_for_destruction
        expect(cycle).to be_valid
      end
    end
  end

  context 'methods' do

    context '#due_between?' do
      before { Timecop.travel Date.new 2013, 4, 1 }
      after { Timecop.return }

      it 'returns date when range in due date' do
        due_ons.build day: 4, month: 4
        due_ons.build day: 3, month: 5
        expect(due_ons.due_between? date_range_covering_due_on)
          .to eq [Date.new(2013, 4, 4), Date.new(2013, 5, 3)]
      end

      it 'returns nils when range outside due date' do
        due_ons.build day: 1, month: 2
        expect(due_ons.due_between? date_range_missing_due_on)
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

    context '#clear_up_form' do
      it 'will destroy empty due_ons' do
        due_ons.build day: nil, month: nil
        due_ons.clear_up_form
        expect(due_ons.reject { |due_on| due_on.marked_for_destruction? }.size)
                      .to eq(0)
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

      context '#includes_new?' do
        it 'true with new persistable record' do
          due_ons.build day: 1, month: 1
          expect(due_ons).to be_includes_new
        end

        it 'false with new empty record' do
          due_ons.build
          expect(due_ons).to_not be_includes_new
        end
      end
    end

    context 'creating, saving and loading' do

      it 'new on date' do
        cycle = ChargeCycle.new id: 1, name: 'Anything', order: 1
        cycle.prepare
        cycle.due_ons.build day: 24, month: 6
        cycle.due_ons.build day: 25, month: 12
        cycle.save!
        reload = ChargeCycle.find(cycle.id)
        expect(reload.due_ons.size).to eq(2)
      end

      it 'on date to different on date' do
        cycle = ChargeCycle.new id: 1, name: 'Anything', order: 1
        cycle.due_ons.build day: 24, month: 6, id: 7
        cycle.due_ons.build day: 25, month: 12, id: 8
        cycle.due_ons.prepare
        cycle.save!
        load = ChargeCycle.find(cycle.id)
        load.due_ons.prepare
        load.due_ons[0].update day: 5, month: 1
        load.due_ons[1].update day: '', month: ''
        load.save!
        reloaded = ChargeCycle.find(cycle.id)
        expect(reloaded.due_ons.size).to eq(1)
      end

      it 'new per date' do
        cycle = ChargeCycle.new id: 1, name: 'Anything', order: 1
        cycle.due_ons.prepare
        cycle.due_ons.build day: 5, month: -1
        cycle.save!
        load = ChargeCycle.find(cycle.id)
        expect(load.due_ons.size).to eq(12)
      end

      it 'per month to different per month' do
        charge_per_date = ChargeCycle.new id: 1, name: 'Anything', order: 1
        charge_per_date.prepare
        charge_per_date.due_ons.build day: 24, month: -1
        charge_per_date.save!
        charge_diff_date = ChargeCycle.find(charge_per_date.id)
        charge_diff_date.prepare
        charge_diff_date.due_ons.build day: 10, month: -1
        charge_diff_date.save!
        charge_reload = ChargeCycle.find(charge_per_date.id)
        expect(charge_reload.due_ons.size).to eq(12)
      end

      it 'per month to same per month' do
        charge = ChargeCycle.new id: 1, name: 'Anything', order: 1
        charge.prepare
        charge.due_ons.build day: 24, month: -1
        charge.save!
        reload = ChargeCycle.find(charge.id)
        reload.prepare
        reload.due_ons.build day: 24, month: -1
        reload.save!
        reload2 = ChargeCycle.find(charge.id)
        reload2.prepare
        expect(reload2.due_ons.size).to eq(12)
      end

      it 'on date to per month' do
        charge = ChargeCycle.new id: 1, name: 'Anything', order: 1
        charge.due_ons.build day: 24, month: 6
        charge.due_ons.build day: 25, month: 12
        charge.prepare
        charge.save!
        reload = ChargeCycle.find(charge.id)
        reload.prepare
        reload.due_ons.build day: 10, month: -1
        reload.save!
        reload2 = ChargeCycle.find(charge.id)
        expect(reload2.due_ons.size).to eq(12)
      end

      it 'per month to on date' do
        charge = ChargeCycle.new id: 1, name: 'Anything', order: 1
        charge.prepare
        charge.due_ons.build day: 24, month: -1
        charge.save!
        reload = ChargeCycle.find(charge.id)
        reload.prepare
        reload.due_ons.build day: 1, month: 5
        reload.due_ons.build day: 1, month: 11
        reload.save!
        reload2 = ChargeCycle.find(charge.id)
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
