require 'rails_helper'

# Required for splitting over two lines.
# rubocop: disable Style/SpaceInsideRangeLiteral

describe DueOns, :ledgers, type: :model do

  let(:cycle) do
    ChargeCycle.new id: 1,
                    name: 'Anything',
                    order: 1,
                    cycle_type: 'term'
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

  describe 'methods' do
    describe '#between' do
      it 'returns date when range in due date' do
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 4, month: 4),
                                           DueOn.new(day: 3, month: 5)]
        expect(cycle.due_ons.between Date.new(2015, 4, 4)..Date.new(2016, 5, 5))
          .to eq [Date.new(2015, 4, 4), Date.new(2015, 5, 3),
                  Date.new(2016, 4, 4), Date.new(2016, 5, 3)]
      end

      it 'returns nils when range outside due date' do
        due_ons.build day: 1, month: 2
        expect(due_ons.between Date.new(2013, 4, 4)..Date.new(2013, 5, 2))
          .to be_empty
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
        it 'new monthly' do
          (cycle = charge_cycle_new cycle_type: 'monthly', due_ons: nil)
            .prepare
          cycle.due_ons[0].update day: 5
          cycle.save!
          expect(ChargeCycle.first.due_ons.size).to eq(12)
        end

        it 'changes to different monthly' do
          cycle = charge_cycle_monthly_create day: 2, prepare: true
          cycle.due_ons[0].update day: 3
          cycle.save!
          expect(ChargeCycle.first.due_ons[11].day).to eq(3)
        end
      end
    end
    describe '#to_s' do
      it 'outputs the due_ons array' do
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 3),
                                           DueOn.new(day: 30, month: 9)]
        expect(cycle.due_ons.to_s).to eq 'due_ons: [Mar 25], [Sep 30]'
      end
    end
  end
end
