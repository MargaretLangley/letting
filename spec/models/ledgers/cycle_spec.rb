require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe Cycle, :ledgers, :range, type: :model do
  describe 'validates' do
    it('returns valid') { expect(cycle_new).to be_valid }
    it('requires a name') { expect(cycle_new name: '').to_not be_valid }
    it('requires an order') { expect(cycle_new order: '').to_not be_valid }
    it 'requires a cycle_type' do
      (cycle = cycle_new).cycle_type = ''
      expect(cycle).to_not be_valid
    end
    it 'includes cycle_type of term' do
      (cycle = cycle_new).cycle_type = 'term'
      expect(cycle).to be_valid
    end
    it 'includes cycle_type of monthly' do
      (cycle = cycle_new).cycle_type = 'monthly'
      expect(cycle).to be_valid
    end
    it 'no other cycle_type accepted' do
      (cycle = cycle_new).cycle_type = 'anything'
      expect(cycle).to_not be_valid
    end
  end

  describe '#monthly?' do
    it 'is monthly when initialized monthly' do
      expect(cycle_new(cycle_type: 'monthly')).to be_monthly
    end

    it 'is not monthly when initialized term' do
      expect(cycle_new(cycle_type: 'term')).to_not be_monthly
    end
  end

  describe '#repeated_dates' do
    it 'calculates dates' do
      cycle = cycle_new due_ons: [DueOn.new(day: 1, month: 1),
                                  DueOn.new(day: 6, month: 6)]
      expect(cycle.repeated_dates(year: 1980))
       .to eq [Date.new(1980, 1, 1), Date.new(1980, 6, 6)]
    end
  end

  describe '#between_range' do
    it 'creates a charging date when in range'  do
      cycle = cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      expect(cycle.between(Date.new(2013, 3, 25)..Date.new(2013, 3, 25)))
        .to eq [Date.new(2013, 3, 25)]
    end
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      cycle = cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      other = cycle_new due_ons: [DueOn.new(day: 25, month: 3)]
      expect(cycle <=> other).to eq 0
    end

    it 'equality is order independent' do
      cycle = cycle_new due_ons: [DueOn.new(day: 1, month: 1),
                                  DueOn.new(day: 6, month: 6)]

      other = cycle_new due_ons: [DueOn.new(day: 6, month: 6),
                                  DueOn.new(day: 1, month: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'ignores cycle name in matching' do
      cycle = cycle_new name: 'Mar/Sep', due_ons: [DueOn.new(day: 1, month: 1)]
      other = cycle_new name: 'Jan/Dec', due_ons: [DueOn.new(day: 1, month: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'returns 1 when lhs > rhs' do
      lhs = cycle_new due_ons: [DueOn.new(day: 6, month: 6)]
      rhs = cycle_new due_ons: [DueOn.new(day: 1, month: 1)]
      expect(lhs <=> rhs).to eq(1)
    end

    it 'returns -1 when lhs < rhs' do
      lhs = cycle_new due_ons: [DueOn.new(day: 1, month: 1)]
      rhs = cycle_new due_ons: [DueOn.new(day: 6, month: 6)]
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(due_on_new(day: 2, month: 2) <=> 37).to be_nil
    end
  end

  describe 'form preparation' do
    context 'term' do
      it '#prepare creates children' do
        cycle = cycle_new cycle_type: 'term', due_ons: nil
        expect(cycle.due_ons.size).to eq(0)
        cycle.prepare
        expect(cycle.due_ons.size).to eq(4)
      end

      it '#clear_up_form destroys children' do
        cycle = cycle_new cycle_type: 'term',
                          due_ons: [DueOn.new(day: 25, month: 3)]
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons.reject(&:marked_for_destruction?).size).to eq(1)
      end
    end

    context 'monthly' do
      it '#prepare creates children' do
        cycle = cycle_new cycle_type: 'monthly', due_ons: nil
        expect(cycle.due_ons.size).to eq(0)
        cycle.prepare
        expect(cycle.due_ons.size).to eq(12)
      end

      it '#clear_up_form keeps children if day set' do
        cycle = cycle_new cycle_type: 'monthly', due_ons: nil
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons.reject(&:marked_for_destruction?).size).to eq(0)
      end

      it '#clear_up_form destroys children if empty' do
        cycle = cycle_new cycle_type: 'monthly',
                          due_ons: [DueOn.new(day: 25, month: 3)]
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons.reject(&:marked_for_destruction?).size).to eq(12)
      end
    end
  end
  describe '#to_s' do
    it 'displays' do
      expect(cycle_new.to_s)
        .to eq 'cycle: Mar/Sep, type: term, due_ons: [Mar 25]'
    end
  end
end
