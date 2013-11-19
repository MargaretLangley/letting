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

    context '#prepare_debits' do
      before { Timecop.travel(Date.new(2013, 1, 31)) }
      after { Timecop.return }

      it 'generates debits when charges due' do
        account = account_and_charge_new charge_attributes: { id: 3 }
        debits = account.prepare_debits(dates_in_march)
        expect(debits).to have(1).items
        debit = debits.first
        expect(debit.account_id).to eq 1
        expect(debit.charge_id).to eq 3
        expect(debit.on_date).to eq Date.new 2013, 3, 25
        expect(debit.amount).to eq 88.08
      end

      it 'does not double charge' do
        account = account_and_charge_new charge_attributes: { id: 1 }
        account.debits.build debit_attributes
        expect(account.prepare_debits(dates_in_march)).to eq []
      end

      def dates_in_march
        Date.new(2013, 3, 1)..Date.new(2013, 3, 31)
      end
    end

    context '#prepare_credits' do
      before { Timecop.travel(Date.new(2013, 1, 31)) }
      after { Timecop.return }

      it 'no debit - does nothing' do
        expect(account.prepare_credits).to have(0).items
      end

      context 'unpaid_debits' do

        it 'unpaid debits generates matching credits' do
          account.debits.push debit_new
          credits = account.prepare_credits
          expect(credits).to have(1).items
          expect(credits.first.amount).to be_nil
          credits.first.amount = 0
          expect(credits.first).to be_valid
        end

        it 'paid debits nothing generated' do
          Debit.any_instance.stub(:paid?).and_return true
          account.debits.push debit_new
          expect(account.prepare_credits).to have(0).items
        end
      end

      context 'advanced credits' do
        it 'one advanced charge per charge type only' do
          account = account_and_charge_new charge_attributes: { id: 3 }

          credits = account.prepare_credits

          expect(credits).to have(1).items
        end

        it 'sets date to current' do
          expect(advanced_credit.on_date).to eq Date.current
        end

        it 'sets amount to zero' do
          expect(advanced_credit.amount).to eq 0.0
        end

        def advanced_credit
          account = account_and_charge_new charge_attributes: { id: 3 }
          credits = account.prepare_credits
          credits.first
        end
      end
    end

    it '#by_human id' do
      property_create!
      expect(Account.by_human_ref(2002)).to be_present
    end
  end

end
