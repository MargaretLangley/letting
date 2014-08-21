require 'rails_helper'

describe 'ChargeStructure Factory' do
  describe 'stuff' do
    it 'is valid' do
      expect(charge_structure_new).to be_valid
    end

    describe 'create' do
      context 'default' do
        it 'is created' do
          expect { charge_structure_create }
            .to change(ChargeStructure, :count).by(1)
        end

        describe 'charge_cycle' do
          it 'makes charge_cycle' do
            expect { charge_structure_create }
              .to change(ChargeCycle, :count).by(1)
          end

          it 'makes due_on' do
            expect { charge_structure_create }
              .to change(DueOn, :count).by(1)
          end

          it 'makes due_on' do
            charge_structure_create
            expect(DueOn.first).to eq DueOn.new(day: 25, month: 3)
          end
        end
      end

      describe 'overrides' do
        describe 'id' do
          it 'can be overriden' do
            structure = charge_structure_create id: 6
            expect(structure.id).to eq 6
          end
        end
        describe 'charged_in' do
          it 'can be overriden' do
            structure = charge_structure_create \
                          charged_in: charged_in_create(id: 3)
            expect(structure.charged_in_id).to eq 3
          end
        end
        describe 'charge_cycle' do
          it 'can be overriden' do
            cycle = charge_cycle_create id: 8
            structure = charge_structure_create charge_cycle: cycle
            expect(structure.charge_cycle.id).to eq 8
          end

          it 'updates the day' do
            cycle = charge_cycle_create due_on_attributes: { day: 10 }
            structure = charge_structure_create charge_cycle: cycle
            expect(structure.charge_cycle.due_ons.first.day).to eq 10
          end
        end
      end
    end
  end
end
