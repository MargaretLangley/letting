require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe Cycle, :ledgers, :range, :cycle, type: :model do
  describe 'validates' do
    it('returns valid') { expect(cycle_new).to be_valid }
    it('requires a name') { expect(cycle_new name: '').to_not be_valid }
    it('charged_in') { expect(cycle_new charged_in: nil).to_not be_valid }
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

  describe '#between' do
    it 'returns the date of the matching due_on' do
      cycle = cycle_new due_ons: [DueOn.new(day: 1, month: 1)]
      expect(cycle.between(Date.new(1980, 1, 1)..Date.new(1980, 1, 2)))
        .to eq [MatchedCycle.new(Date.new(1980, 1, 1),
                                 Date.new(1980, 1, 1)..Date.new(1980, 12, 31))]
    end

    it 'returns nothing on mismatching due_on' do
      cycle = cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

      expect(cycle.between Date.new(1980, 2, 1)..Date.new(1980, 3, 4)).to eq []
    end

    it 'returns the dates of all the matching due_ons' do
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 4),
                                  DueOn.new(month: 9, day: 5),]

      expect(cycle.between Date.new(2010, 3, 1)..Date.new(2011, 2, 28))
        .to eq [MatchedCycle.new(Date.new(2010, 3, 4),
                                 Date.new(2010, 3, 4)..Date.new(2010, 9, 4)),
                MatchedCycle.new(Date.new(2010, 9, 5),
                                 Date.new(2010, 9, 5)..Date.new(2011, 3, 3))]
    end

    it 'returns a due_on date for each matching year' do
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 5)]

      expect(cycle.between Date.new(2010, 3, 1)..Date.new(2012, 3, 6))
        .to eq [MatchedCycle.new(Date.new(2010, 3, 5),
                                 Date.new(2010, 3, 5)..Date.new(2011, 3, 4)),
                MatchedCycle.new(Date.new(2011, 3, 5),
                                 Date.new(2011, 3, 5)..Date.new(2012, 3, 4)),
                MatchedCycle.new(Date.new(2012, 3, 5),
                                 Date.new(2012, 3, 5)..Date.new(2013, 3, 4))]
    end
  end

  describe '#billed_period' do
    it 'displays due_date range by default' do
      due_on = DueOn.new month: 3, day: 5
      cycle = cycle_new due_ons: [due_on]
      expect(cycle.bill_period billed_on: Date.new(2000, 3, 5))
        .to eq Date.new(2000, 3, 5)..Date.new(2001, 3, 4)
    end

    it 'displays show range when present' do
      due_on = DueOn.new month: 3, day: 5, show_month: 4, show_day: 10
      cycle = cycle_new due_ons: [due_on]
      expect(cycle.bill_period billed_on: Date.new(2000, 4, 10))
        .to eq Date.new(2000, 4, 10)..Date.new(2001, 4, 9)
    end

    it 'errors when show range present and billed_date past due_date ' do
      due_on = DueOn.new month: 3, day: 5, show_month: 4, show_day: 10
      cycle = cycle_new due_ons: [due_on]
      expect(cycle.bill_period billed_on: Date.new(2000, 3, 5))
        .to eq :missing_due_on
    end
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      cycle = Cycle.new charged_in_id: 0, due_ons: [DueOn.new(day: 25, month: 3)]
      other = Cycle.new charged_in_id: 0, due_ons: [DueOn.new(day: 25, month: 3)]
      expect(cycle <=> other).to eq 0
    end

    it 'equality is order independent' do
      cycle = Cycle.new charged_in_id: 0, due_ons: [DueOn.new(day: 1, month: 1),
                                                    DueOn.new(day: 6, month: 6)]

      other = Cycle.new charged_in_id: 0, due_ons: [DueOn.new(day: 6, month: 6),
                                                    DueOn.new(day: 1, month: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'ignores cycle name in matching' do
      cycle = cycle_new name: 'Mar/Sep', due_ons: [DueOn.new(day: 1, month: 1)]
      other = cycle_new name: 'Jan/Dec', due_ons: [DueOn.new(day: 1, month: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'uses charged_id in matching' do
      cycle = Cycle.new charged_in_id: 1, due_ons: [DueOn.new(day: 1, month: 1)]
      other = Cycle.new charged_in_id: 2, due_ons: [DueOn.new(day: 1, month: 1)]
      expect(cycle <=> other).to eq(-1)
    end

    it 'returns 1 when lhs > rhs for due_ons' do
      lhs = Cycle.new charged_in_id: 1, due_ons: [DueOn.new(day: 6, month: 6)]
      rhs = Cycle.new charged_in_id: 1, due_ons: [DueOn.new(day: 1, month: 1)]
      expect(lhs <=> rhs).to eq(1)
    end

    it 'returns 1 when lhs > rhs for charged_in' do
      lhs = Cycle.new charged_in_id: 2, due_ons: [DueOn.new(day: 6, month: 6)]
      rhs = Cycle.new charged_in_id: 1, due_ons: [DueOn.new(day: 6, month: 6)]
      expect(lhs <=> rhs).to eq(1)
    end

    it 'returns -1 when lhs < rhs' do
      lhs = Cycle.new charged_in_id: 1, due_ons: [DueOn.new(day: 1, month: 1)]
      rhs = Cycle.new charged_in_id: 1, due_ons: [DueOn.new(day: 6, month: 6)]
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns -1 when lhs < rhs for charged_in' do
      lhs = Cycle.new charged_in_id: 1, due_ons: [DueOn.new(day: 6, month: 6)]
      rhs = Cycle.new charged_in_id: 2, due_ons: [DueOn.new(day: 6, month: 6)]
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(Cycle.new(charged_in_id: 1, due_ons: [DueOn.new(day: 6, month: 6)]) <=> 37).to be_nil
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
        .to eq 'cycle: Mar, type: term, charged_in: 2, due_ons: [Mar 25]'
    end
  end
end
