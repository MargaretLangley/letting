# rubocop: disable Style/LineLength

require 'rails_helper'

describe 'ChargeCycle Factory', :ledgers do

  describe 'new' do
    context 'default' do
      it('has name') { expect(charge_cycle_new.name).to eq 'Mar/Sep' }
      it('has term period_type') { expect(charge_cycle_new.period_type).to eq 'term' }
      it 'has due_on' do
        expect(charge_cycle_new.due_ons.size).to eq 1
      end
      it 'has due_on on date' do
        expect(charge_cycle_new.due_ons[0].day).to eq 25
        expect(charge_cycle_new.due_ons[0].month).to eq 3
      end
    end
    describe 'overrides' do
      it 'changes period_type' do
        charge_cycle_new period_type: ''
      end
      it 'changes due ons' do
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
        expect(cycle.due_ons[0].month).to eq 6
      end
    end
  end

  describe 'create' do
    context 'default' do
      it('is valid') { expect(charge_cycle_create).to be_valid }

      it 'is created' do
        expect { charge_cycle_create }.to change(ChargeCycle, :count).by(1)
      end
      it 'makes due_on' do
        expect { charge_cycle_create }.to change(DueOn, :count).by(1)
      end

      describe 'adds' do
        it 'due date due_ons' do
          charge_cycle_create due_ons: [DueOn.new(day: 2, month: 3)]
          expect(ChargeCycle.first.due_ons.first)
            .to eq DueOn.new(day: 2, month: 3)
        end

        it 'per month due_ons' do
          charge_cycle_create period_type: 'monthly',
                              due_ons: [DueOn.new(day: 2)],
                              prepare: true
          expect(ChargeCycle.first.due_ons.size).to eq(12)
        end
      end
    end

    describe 'overrides' do
      it('id') { expect((charge_cycle_create id: 7).id).to eq 7 }

      it 'due on' do
        charge_cycle_create due_ons: [DueOn.new(day: 6, month: 10)]
        expect(DueOn.first).to eq DueOn.new(day: 6, month: 10)
      end
    end
  end
end
