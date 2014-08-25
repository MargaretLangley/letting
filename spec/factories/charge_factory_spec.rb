require 'rails_helper'

describe 'ChargeFactory' do

  describe 'new' do
    it('is valid') do
      expect(charge_new).to be_valid
    end
    it('has type') { expect(charge_new.charge_type).to eq 'Ground Rent' }
    it('has cycle') { expect(charge_new.charge_cycle.name).to eq 'Mar/Sep' }
    it('has due_ons') { expect(charge_new.charge_cycle.due_ons.size).to eq 1 }
    it 'has expected due date' do
      expect(charge_new.charge_cycle.due_ons[0])
        .to eq DueOn.new(day: 25, month: 3)
    end
  end

  describe 'create' do
    context 'default' do
      it 'is created' do
        expect { charge_create }
          .to change(Charge, :count).by(1)
      end

      it 'has charge type' do
        charge_create
        expect(Charge.first.charge_type).to eq 'Ground Rent'
      end

      it 'is an active charge' do
        charge_create
        expect(Charge.first).to_not be_dormant
      end

      describe 'charge_cycle' do
        it 'makes charge_cycle' do
          expect { charge_create }
            .to change(ChargeCycle, :count).by(1)
        end

        it 'makes due_on' do
          expect { charge_create }.to change(DueOn, :count).by(1)
        end

        it 'makes due_on' do
          charge_create
          expect(DueOn.first).to eq DueOn.new(day: 25, month: 3)
        end
      end
    end

    describe 'override' do
      it 'changes charge type' do
        charge_create charge_type: 'Garage'
        expect(Charge.first.charge_type).to eq 'Garage'
      end

      it 'can be dormant' do
        charge_create dormant: true
        expect(Charge.first).to be_dormant
      end

      it 'can override charged_in' do
        charge_create charged_in: charged_in_create(id: 1, name: 'mid-term')
        expect(ChargedIn.first.name).to eq 'mid-term'
      end

      describe 'charge_cycle' do
        it 'makes due_on' do
          charge_create charge_cycle: charge_cycle_create(id: 5)
          expect(ChargeCycle.first.id).to eq(5)
        end
      end
    end
  end
end
