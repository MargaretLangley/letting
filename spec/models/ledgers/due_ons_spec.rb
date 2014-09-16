require 'rails_helper'

describe DueOns, :ledgers, type: :model do

  let(:cycle) do
    ChargeCycle.new id: 1,
                    name: 'Anything',
                    order: 1,
                    period_type: 'term'
  end
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
        Date.new(2013, 4, 4)..Date.new(2013, 5, 5)
      end

      def date_range_missing_due_on
        Date.new(2013, 4, 4)..Date.new(2013, 5, 2)
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
    end

    describe 'creating, saving and loading' do
      context 'term' do
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
      end

      context 'monthly' do
        it 'new per date' do
          (cycle = charge_cycle_new period_type: 'monthly', due_ons: nil)
            .prepare
          cycle.due_ons[0].update day: 5
          cycle.save!
          expect(ChargeCycle.first.due_ons.size).to eq(12)
        end

        it 'per month to different per month' do
          skip 'implement'
        end

        it 'per month to same per month' do
          skip 'implement'
        end
      end
    end
  end
end
