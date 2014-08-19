require 'rails_helper'

RSpec.describe ChargeCycle, type: :model do
  let(:cycle) do
    cycle = ChargeCycle.new id: 1, name: 'Mar/Sep'
    cycle.due_ons.new day: 25, month: 3, charge_cycle_id: 1
    cycle
  end

  it 'returns valid' do
    expect(cycle).to be_valid
  end

  describe '#due_dates' do
    before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
    after(:each)  { Timecop.return }

    it 'creates charging date if in range'  do
      cycle = ChargeCycle.new id: 1, name: 'Mar/Sep'
      cycle.due_ons.new day: 25, month: 3, charge_cycle_id: 1
      expect(cycle.due_dates(Date.new(2013, 3, 25)..Date.new(2013, 3, 25)))
        .to eq [Date.new(2013, 3, 25)]
    end
  end

  describe '<=>' do
    it 'matches when equal' do
      cycle = ChargeCycle.new(name: 'Mar/Sep')
      cycle.due_ons.build day: 1, month: 1
      cycle.due_ons.build day: 6, month: 6

      other = ChargeCycle.new(name: 'Mar/Sep')
      other.due_ons.build day: 1, month: 1
      other.due_ons.build day: 6, month: 6

      expect(cycle <=> other).to eq 0
    end

    it 'order independent' do
      cycle = ChargeCycle.new(name: 'Mar/Sep')
      cycle.due_ons.build day: 1, month: 1
      cycle.due_ons.build day: 6, month: 6

      other = ChargeCycle.new(name: 'Sep/Mar')
      other.due_ons.build day: 6, month: 6
      other.due_ons.build day: 1, month: 1

      expect(cycle <=> other).to eq 0
    end

    it 'uses due_ons to match' do
      cycle = ChargeCycle.new(name: 'Mar/Sep')
      cycle.due_ons.build day: 1, month: 1
      cycle.due_ons.build day: 6, month: 6

      other = ChargeCycle.new(name: 'Jan/Dec')
      other.due_ons.build day: 1, month: 1
      other.due_ons.build day: 12, month: 12

      expect(cycle <=> other).to eq(-1)
    end
  end

  describe 'form preparation' do
    it 'due_ons' do
      cycle = ChargeCycle.new(name: 'Mar/Sep')
      cycle.due_ons.destroy_all
      expect(cycle).to_not be_valid
    end

    it '#prepare creates children' do
      cycle = ChargeCycle.new(name: 'Mar/Sep')
      cycle.prepare
      expect(cycle.due_ons.size).to eq(4)
    end

    it '#clear_up_form destroys children' do
      cycle = ChargeCycle.new(name: 'Mar/Sep')
      cycle.due_ons.build day: 1, month: 1
      cycle.prepare
      cycle.clear_up_form
      expect(cycle.due_ons
                  .reject { |due_on| due_on.marked_for_destruction? }.size)
        .to eq(1)
    end
  end
end
