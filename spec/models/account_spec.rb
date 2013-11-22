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
        debits = account.prepare_debits(date_when_charged)
        expect(debits).to have(1).items
      end

      it 'generates debits when charges due' do
        account = account_and_charge_new charge_attributes: { id: 3 }
        debits = account.prepare_debits(date_not_charged)
        expect(debits).to have(0).items
      end

      def date_when_charged
        Date.new(2013, 3, 25)..Date.new(2013, 3, 25)
      end

      def date_not_charged
        Date.new(2013, 3, 26)..Date.new(2013, 3, 26)
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

    it '#prepare' do
      expect(account.charges).to have(0).items
      account.prepare_for_form
      expect(account.charges).to have(4).items
    end

    it '#cleans up form' do
      account.charges.build charge_attributes
      account.prepare_for_form
      account.clear_up_form
      expect(account.charges.reject(&:marked_for_destruction?)).to have(1).items
    end

    it '#by_human id' do
      property_create!
      expect(Account.by_human_ref(2002)).to be_present
    end

  end

end
