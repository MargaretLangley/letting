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

    context '#prepare_for_form' do
      it 'creates credits with amount defaulting from debit' do
        expect(account.credits_for_unpaid_debits).to have(0).item
        account.add_debit debit_attributes
        account.prepare_for_form
        expect(account.credits.first.amount).to eq debit_attributes[:amount]
      end

      it 'ignored paid' do
        # credit has associated debit
        account.debits << debit_new
        account.credits << credit_new
        account.save!
        expect(account.debits).to have(1).item
        expect(account.credits_for_unpaid_debits).to have(0).item
      end
    end

    context '#clear_up_form' do
      it 'keeps credits with postive amount' do
        account.add_debit debit_attributes
        account.prepare_for_form
        account.credits.first.amount = 1
        account.clear_up_form
        expect(account.credits.first).to_not be_marked_for_destruction
      end

      it 'removes credits with 0 amount' do
        account.add_debit debit_attributes
        account.prepare_for_form
        account.credits.first.amount = 0
        account.clear_up_form
        expect(account.credits.first).to be_marked_for_destruction
      end
    end

    it '#by_human id' do
      property_create!
      expect(Account.by_human_ref(2002)).to be_present
    end
  end

end
