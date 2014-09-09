require 'rails_helper'

describe DueOns, :ledgers, type: :model do

  let(:cycle) { ChargeCycle.new id: 1, name: 'Anything', order: 1, period_type: 'term'  }
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
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 4, month: 4),
                                           DueOn.new(day: 3, month: 5)]
        expect(cycle.due_ons.due_between? date_range_covering_due_on)
          .to eq [Date.new(2013, 4, 4), Date.new(2013, 5, 3)]
      end

      it 'returns nils when range outside due date' do
        due_ons.build day: 1, month: 2
        expect(due_ons.due_between? date_range_missing_due_on)
          .to be_empty
      end

      def date_range_covering_due_on
        Date.new(2013, 4, 4) .. Date.new(2013, 5, 5)
      end

      def date_range_missing_due_on
        Date.new(2013, 4, 4) .. Date.new(2013, 5, 2)
      end
    end

    describe 'form life cycle' do
      describe '#empty?' do
        it 'is empty when nothing in it' do
          expect(charge_cycle_new(due_ons: nil).due_ons).to be_empty
        end

        it 'not empty when something in it' do
          expect(charge_cycle_new(due_ons: [DueOn.new(day: 1)]).due_ons)
            .to_not be_empty
        end
      end

      it '#prepare fills collection with with empty due_on' do
        due_ons = charge_cycle_new(due_ons: nil).due_ons
        expect(due_ons.size).to eq(0)
        due_ons.prepare
        expect(due_ons.size).to eq(4)
      end

      it '#clear_up_form destroys empty due_ons' do
        due_ons.build day: nil, month: nil
        due_ons.clear_up_form
        expect(due_ons.reject { |due_on| due_on.marked_for_destruction? }.size)
                      .to eq(0)
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

      context '#includes_new_monthly?' do
        it 'true with new persistable record' do
          due_ons.build day: 1, month: -1
          expect(due_ons).to be_includes_new_monthly
        end

        it 'false with new empty record' do
          due_ons.build
          expect(due_ons).to_not be_includes_new_monthly
        end
      end
    end

    context 'creating, saving and loading' do

      it 'new on date' do
        (cycle = charge_cycle_new due_ons: [DueOn.new(day: 24, month: 6),
                                            DueOn.new(day: 25, month: 12)])
          .prepare
        expect(cycle.due_ons.size).to eq(4)
        cycle.save!
        expect(ChargeCycle.first.due_ons.size).to eq(2)
      end

      it 'updates on_date' do
        charge_cycle_create due_ons: [DueOn.new(id: 1, day: 24, month: 6)]
        (cycle = ChargeCycle.first).prepare
        cycle.due_ons[0].day = 23
        cycle.save!
        expect(ChargeCycle.first.due_ons.size).to eq(1)
      end

      it 'adds on_date' do
        charge_cycle_create due_ons: [DueOn.new(day: 24, month: 6)]
        (cycle = ChargeCycle.first).prepare
        cycle.due_ons[1].attributes =  { 'day' => '14', 'month' => '9' }
        cycle.save!
        expect(ChargeCycle.first.due_ons.size).to eq(2)
      end

      it 'removes on_date' do
        charge_cycle_create due_ons: [DueOn.new(day: 24, month: 6),
                                      DueOn.new(day: 25, month: 12)]
        (cycle = ChargeCycle.first).prepare
        cycle.due_ons[1].attributes =  { 'day' => '', 'month' => '' }
        cycle.save!
        expect(ChargeCycle.first.due_ons.size).to eq(1)
      end

      it 'new per date' do
        (cycle = charge_cycle_new due_ons: nil).prepare
        cycle.due_ons[0].update day: 5, month: -1
        cycle.save!
        expect(ChargeCycle.first.due_ons.size).to eq(12)
      end

      it 'per month to different per month' do
        charge_cycle_create due_ons: [DueOn.new(day: 24, month: -1)]
        (cycle = ChargeCycle.first).prepare
        # Fails
        # cycle.due_ons[0].update day: 5, month: -1
        # Passes
        cycle.due_ons.build day: 10, month: -1
        cycle.save!
        expect(ChargeCycle.first.due_ons.size).to eq(12)
      end

      it 'per month to same per month' do
        charge_cycle_create due_ons: [DueOn.new(day: 24, month: -1)]
        (cycle = ChargeCycle.first).prepare
        cycle.due_ons.build day: 24, month: -1
        cycle.save!
        cycle = ChargeCycle.first
        cycle.prepare
        expect(cycle.due_ons.size).to eq(12)
      end
    end
  end
end
