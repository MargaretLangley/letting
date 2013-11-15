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
        account.debits.build debit_attributes
        expect(account.chargeables_between(dates_in_march)).to eq []
      end

      def dates_in_march
        Date.new(2013, 3, 1)..Date.new(2013, 3, 31)
      end
    end

    context '#prepare_credits_for_unpaid_debits' do
      it 'does nothing when no debits' do
        expect(account.prepare_credits_for_unpaid_debits).to have(0).items
      end

      it 'generates credits for upaid debits' do
        account.debits.push debit_new
        credits = account.prepare_credits_for_unpaid_debits
        expect(credits).to have(1).items
        credits.first.amount = 0
        expect(credits.first).to be_valid
      end

      it 'does not generate for paid debits' do
        Debit.any_instance.stub(:paid?).and_return true
        account.debits.push debit_new
        expect(account.prepare_credits_for_unpaid_debits).to have(0).items
      end
    end

    it '#by_human id' do
      property_create!
      expect(Account.by_human_ref(2002)).to be_present
    end
  end

end
