# rubocop: disable Metrics/LineLength

require 'rails_helper'

describe 'Cycle Factory', :ledgers do

  describe 'new' do
    context 'default' do
      it('has name') { expect(cycle_new.name).to eq 'Mar' }
      it('has term cycle_type') { expect(cycle_new.cycle_type).to eq 'term' }
      it 'has due_on' do
        expect(cycle_new.due_ons.size).to eq 1
      end
      it 'has due_on on date' do
        expect(cycle_new.due_ons[0].day).to eq 25
        expect(cycle_new.due_ons[0].month).to eq 3
      end
    end
    describe 'overrides' do
      it 'changes cycle_type' do
        cycle_new cycle_type: ''
      end
      it 'changes due ons' do
        cycle = cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
        expect(cycle.due_ons[0].month).to eq 6
      end
    end
  end

  describe 'create' do
    context 'default' do
      it('is valid') { expect(cycle_create).to be_valid }

      it 'is created' do
        expect { cycle_create }.to change(Cycle, :count).by(1)
      end
      it 'makes due_on' do
        expect { cycle_create }.to change(DueOn, :count).by(1)
      end

      describe 'adds' do
        it 'due date due_ons' do
          cycle_create due_ons: [DueOn.new(day: 2, month: 3)]
          expect(Cycle.first.due_ons.first)
            .to eq DueOn.new(day: 2, month: 3)
        end

        it 'per month due_ons' do
          cycle_create cycle_type: 'monthly',
                       due_ons: [DueOn.new(day: 2)],
                       prepare: true
          expect(Cycle.first.due_ons.size).to eq(12)
        end
      end
    end

    describe 'overrides' do
      it('id') { expect((cycle_create id: 7).id).to eq 7 }

      it 'due on' do
        cycle_create due_ons: [DueOn.new(day: 6, month: 10)]
        expect(DueOn.first).to eq DueOn.new(day: 6, month: 10)
      end
    end

    describe 'creates monthly' do
      it 'is valid' do
        expect(cycle_monthly_create.due_ons.count).to eq(12)
      end
    end
  end
end
