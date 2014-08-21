require 'rails_helper'

RSpec.describe ChargeStructure, type: :model do
  let(:structure) do
    structure = ChargeStructure.new charge_cycle_id: 1, charged_in_id: 1
    structure.build_charge_cycle id: 1, name: 'Mar/Sep'
    structure.build_charged_in id: 1, name: 'Arrears'
    structure
  end

  describe 'valid' do
    it 'requires charge_cycle_id' do
      structure.charge_cycle_id = nil
      expect(structure).to_not be_valid
    end
    it 'requires charged_in_id' do
      structure.charged_in_id = nil
      expect(structure).to_not be_valid
    end
  end

  describe 'methods' do
    describe 'returns delegated attribute' do
      it 'charge_cycle_cycle as string' do
        expect(structure.charge_cycle_name).to be_kind_of(String)
      end

      it 'charged_in_name as string' do
        expect(structure.charged_in_name).to be_kind_of(String)
      end
    end

    describe '#due_dates' do
      before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
      after(:each)  { Timecop.return }

      it 'creates charging date if in range'  do
        cycle = ChargeCycle.new id: 1, name: 'Mar/Sep'
        cycle.due_ons.new day: 25, month: 3, charge_cycle_id: 1
        structure.charge_cycle = cycle
        expect(structure.charge_cycle.due_dates(Date.new(2013, 3, 25)..\
                                   Date.new(2013, 3, 25)))
          .to eq [Date.new(2013, 3, 25)]
      end
    end

    describe '<=>' do
      it 'matches when equal' do
        structure = ChargeStructure.new(charged_in_id: 1, charge_cycle_id: 2)
        other = ChargeStructure.new(charged_in_id: 1, charge_cycle_id: 2)
        expect(structure <=> other).to eq 0
      end

      it 'uses charged_in_id to match' do
        structure = ChargeStructure.new(charged_in_id: 1)
        other = ChargeStructure.new(charged_in_id: 12)
        expect(structure <=> other).to eq(-1)
      end

      it 'uses charge_cycle to match' do
        structure = ChargeStructure.new(charged_in_id: 1, charge_cycle_id: 2)
        other = ChargeStructure.new(charged_in_id: 1, charge_cycle_id: 8)
        expect(structure <=> other).to eq(-1)
      end
    end
  end
end
