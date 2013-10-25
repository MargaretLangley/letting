require 'spec_helper'

describe Account do

  let(:account) { account_new  }
  it('is valid') { expect(account).to be_valid }

  context 'assocations' do
    context 'has many' do
      it('charges')  { expect(account).to respond_to(:charges) }
      it('debits')    { expect(account).to respond_to(:debits) }
      it('credits')  { expect(account).to respond_to(:credits) }
    end
    context 'belongs to' do
      it('property') { expect(account).to respond_to(:property) }
    end
  end

  context 'methods' do

    context '#chargeables_between' do
      before { Timecop.travel(Date.new(2013, 1, 31)) }
      after { Timecop.return }

      it 'generated when charges' do
        account = account_and_charge_new charge_attributes: { id: 3 }
        chargeable = account.chargeables_between(dates_in_march).first
        expect(chargeable.account_id).to eq 1
        expect(chargeable.charge_id).to eq 3
        expect(chargeable.on_date).to eq Date.new(2013, 3, 25)
        expect(chargeable.amount).to eq 88.08
      end

      it 'does not double charge' do
        account = account_and_charge_new charge_attributes: { id: 1 }
        account.add_debit debit_attributes
        expect(account.chargeables_between(dates_in_march)).to eq []
      end

      def dates_in_march
        Date.new(2013, 3, 1)..Date.new(2013, 3, 31)
      end
    end

    it '#add_debit' do
      expect(account.add_debit debit_attributes).to be_valid
    end

    context '#upaid_debits' do

      it 'includes unpaid' do
        debit1 = account.add_debit debit_attributes
        account.save!
        expect(account.debits).to have(1).item
        expect(account.unpaid_debits).to eq [debit1]
      end

      it 'ignored paid' do
        # credit has associated debit
        account.credits << credit_new
        account.save!
        expect(account.debits).to have(1).item
        expect(account.unpaid_debits).to eq []
      end
    end

    it '#by_human id' do
      property_create!
      expect(Account.by_human_id(2002)).to be_present
    end
  end

end
