require 'rails_helper'

describe 'ChargeFactory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(charge_new).to be_valid }
      it('has account_id') { expect(charge_new.account_id).to eq 2 }
      it('has charge_cycle_id') { expect(charge_new.charge_cycle_id).to be_nil }
      it('has charged_in_id') { expect(charge_new.charged_in_id).to eq 2 }
      it('has type') { expect(charge_new.charge_type).to eq 'Ground Rent' }
      it('has cycle') { expect(charge_new.charge_cycle.name).to eq 'Mar/Sep' }
      it 'has due_ons' do
        expect(charge_new.charge_cycle.due_ons.size).to eq 1
      end
      it 'has due ons' do
        expect(charge_new.charge_cycle.due_ons[0])
          .to eq DueOn.new(day: 25, month: 3)
      end
      describe 'makes' do
        it 'creates charged_in' do
          expect(charge_new.charged_in.name).to eq 'Advance'
        end
        it 'creates charge_cycle' do
          expect(charge_new.charge_cycle.name).to eq 'Mar/Sep'
        end
      end
    end
  end

  describe 'create' do
    context 'default' do
      it 'is created' do
        expect { charge_create }.to change(Charge, :count).by(1)
      end

      it 'has charge type' do
        charge_create
        expect(Charge.first.charge_type).to eq 'Ground Rent'
      end

      it 'is an active charge' do
        charge_create
        expect(Charge.first).to_not be_dormant
      end

      describe 'makes' do
        it 'creates charged_in' do
          expect { charge_create }.to change(ChargedIn, :count).by(1)
        end
        it 'creates charge_cycle' do
          expect { charge_create }.to change(ChargeCycle, :count).by(1)
        end
      end
    end

    describe 'override' do
      it 'alters charge type' do
        charge_create charge_type: 'Garage'
        expect(Charge.first.charge_type).to eq 'Garage'
      end

      it('flips dormant') { expect(charge_create dormant: true).to be_dormant }

      it 'alters charged_in' do
        charge_create charged_in: charged_in_create(id: 1, name: 'mid-term')
        expect(ChargedIn.first.name).to eq 'mid-term'
      end
    end

    describe 'adds' do
      it 'can add charge_cycle' do
        expect do
          charge_create charge_cycle: charge_cycle_create(id: 5)
        end.to change(ChargeCycle, :count).by(1)
        expect(ChargeCycle.first.id).to eq(5)
      end
    end
  end
end
