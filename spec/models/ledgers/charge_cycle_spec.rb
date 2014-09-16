require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe ChargeCycle, :ledgers, :range, type: :model do
  describe 'validates' do
    it('returns valid') { expect(charge_cycle_new).to be_valid }
    it('requires a name') { expect(charge_cycle_new name: '').to_not be_valid }
    it('requires an order') { expect(charge_cycle_new order: '').to_not be_valid }
    it 'requires a period_type' do
      (charge_cycle = charge_cycle_new).period_type = ''
      expect(charge_cycle).to_not be_valid
    end
  end

  describe '#due_between?' do
    before(:each) { Timecop.travel Date.new(2013, 1, 31) }
    after(:each)  { Timecop.return }

    it 'creates a charging date when in range'  do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      expect(cycle.due_between?(Date.new(2013, 3, 25)..Date.new(2013, 3, 25)))
        .to eq [Date.new(2013, 3, 25)]
    end
  end

  describe '<=>' do
    it 'matches when equal' do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      other = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      expect(cycle <=> other).to eq 0
    end

    it 'is order independent' do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 1, month: 1),
                                         DueOn.new(day: 6, month: 6)]

      other = charge_cycle_new due_ons: [DueOn.new(day: 6, month: 6),
                                         DueOn.new(day: 1, month: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'ignores cycle name in matching' do
      cycle = charge_cycle_new name: 'Mar/Sep',
                               due_ons: [DueOn.new(day: 1, month: 1)]
      other = charge_cycle_new name: 'Jan/Dec',
                               due_ons: [DueOn.new(day: 1, month: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'does not match a cycle with different due_on' do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 1, month: 1)]
      other = charge_cycle_new due_ons: [DueOn.new(day: 6, month: 6)]
      expect(cycle <=> other).to eq(-1)
    end
  end

  describe 'form preparation' do
    context 'term' do
      it '#prepare creates children' do
        cycle = charge_cycle_new period_type: 'term', due_ons: nil
        expect(cycle.due_ons.size).to eq(0)
        cycle.prepare
        expect(cycle.due_ons.size).to eq(4)
      end

      it '#clear_up_form destroys children' do
        cycle = charge_cycle_new period_type: 'term',
                                 due_ons: [DueOn.new(day: 25, month: 3)]
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons
                    .reject { |due_on| due_on.marked_for_destruction? }.size)
          .to eq(1)
      end
    end

    context 'monthly' do
      it '#prepare creates children' do
        cycle = charge_cycle_new period_type: 'monthly', due_ons: nil
        expect(cycle.due_ons.size).to eq(0)
        cycle.prepare
        expect(cycle.due_ons.size).to eq(12)
      end

      it '#clear_up_form keeps children if day set' do
        cycle = charge_cycle_new period_type: 'monthly', due_ons: nil
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons
                    .reject { |due_on| due_on.marked_for_destruction? }.size)
          .to eq(0)
      end

      it '#clear_up_form destroys children if empty' do
        cycle = charge_cycle_new period_type: 'monthly',
                                 due_ons: [DueOn.new(day: 25, month: 3)]
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons
                    .reject { |due_on| due_on.marked_for_destruction? }.size)
          .to eq(12)
      end
    end
  end

  describe 'range' do
    before { Timecop.travel Date.new(2014, 1, 31) }
    after  { Timecop.return }
    # currently returning the 'on_date' which initialized
    # the Repeat range - but will eventually be the range
    it 'due on can find their range' do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 6, month: 6)]
      expect(cycle.range_on Date.new(2014, 6, 6)).to eq Date.new(2014, 6, 6)
    end

    it 'errors when due on not found' do
      cycle = charge_cycle_new due_ons: [DueOn.new(day: 12, month: 12)]
      expect(cycle.range_on Date.new(2014, 6, 6)).to eq :missing_due_on
    end
  end
end
