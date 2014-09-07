require 'rails_helper'

describe 'Account Factory' do

  describe 'new' do
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
    describe 'adds' do
      it 'can add charge' do
        expect(account_new(charge: charge_new).charges[0].charge_type)
          .to eq 'Ground Rent'
      end
      it 'can add charge_cycle' do
        expect(account_new(charge: charge_new).charges[0].charge_cycle.name)
          .to eq 'Mar/Sep'
      end
      it 'can add due_on' do
        expect(account_new(charge: charge_new)
          .charges[0].charge_cycle.due_ons[0])
            .to eq DueOn.new(day: 25, month: 3)
      end
      it 'can add debit' do
        expect(account_new(debit: debit_new(amount: 17)).debits[0].amount)
          .to eq 17
      end
      it 'can add credit' do
        expect(account_new(credit: credit_new(amount: 17)).credits[0].amount)
          .to eq 17
      end
      it 'can add payment' do
        expect(account_new(payment: payment_new(amount: 17)).payments[0].amount)
          .to eq 17
      end
    end
  end
end
