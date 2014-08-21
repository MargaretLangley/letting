require 'rails_helper'

describe 'ChargeCycle Factory' do

  let(:cycle) { charge_cycle_create name: 'Mar/Sep' }
  it('is valid') { expect(cycle).to be_valid }

  describe 'create' do
    context 'default' do
      it 'is created' do
        expect { charge_cycle_create }
          .to change(ChargeCycle, :count).by(1)
      end
      it 'makes due_on' do
        expect { charge_cycle_create }
          .to change(DueOn, :count).by(1)
      end

      it 'makes due_on' do
        charge_cycle_create
        expect(DueOn.first).to eq DueOn.new(day: 25, month: 3)
      end
    end

    describe 'overrides' do
      it 'id' do
        expect((charge_cycle_create id: 7).id).to eq 7
      end
      it 'due on' do
        charge_cycle_create due_on: DueOn.new(day: 6, month: 10)
        expect(DueOn.first).to eq DueOn.new(day: 6, month: 10)
      end
    end
  end

  describe 'new' do
    describe 'overrides' do
      it('due on') do
        structure = charge_cycle_new due_on_attributes: { month: 6 }
        expect(structure.due_ons[0].month).to eq 6
      end
    end
  end
end
