require 'rails_helper'

describe 'Account Factory' do

  describe 'account_new' do
    describe 'default' do
      it('is valid') { expect(account_new).to be_valid }
      it('no id') { expect(account_new.id).to eq 1 }
      it('change id') { expect(account_new(id: 2).id).to eq 2 }
      it('has property') { expect(account_new.property_id).to eq 1 }
      it 'change property' do
        expect(account_new(property_id: 2).property_id).to eq 2
      end
      it('has no charge') { expect(Charge.count).to eq 0 }
    end
    describe 'adding charge' do
      it 'has charge' do
        expect(account_new(charge: charge_new).charges[0].charge_type)
          .to eq 'Ground Rent'
      end
      it 'has charge_cycle' do
        expect(account_new(charge: charge_new).charges[0].charge_cycle.name)
          .to eq 'Mar/Sep'
      end

      it 'has due_on' do
        expect(account_new(charge: charge_new).charges[0].charge_cycle.due_ons[0])
          .to eq DueOn.new(day: 25, month: 3)
      end
    end
  end
end
