require 'spec_helper'

describe Account do

  let(:account) { account_new  }
  it('is valid') { expect(account).to be_valid }

  context 'methods' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after { Timecop.return }

    context '#prepare_debits' do
      it 'generates debits when charges due' do
        account = account_and_charge_new charge_attributes: { id: 3 }
        debits = account.prepare_debits(date_when_charged)
        expect(debits).to have(1).item
      end

      it 'no debits when no charges due' do
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
      it 'no debit - does nothing' do
        expect(account.prepare_credits).to have(0).items
      end

      context 'receivables' do
        it 'generate matching credits' do
          account.debits.push debit_new
          expect(credits = account.prepare_credits).to have(1).item
          expect(credits.first.amount).to be_nil
        end

        it 'no recievables, no credits' do
          Debit.any_instance.stub(:paid?).and_return true
          account.debits.push debit_new
          expect(account.prepare_credits).to have(0).items
        end
      end
    end

    context '#prepare_payment' do
      it 'no debit - does nothing' do
        march_quarters = Date.new(2013, 3, 25)..Date.new(2016, 3, 25)
        expect(account.prepare_payment(march_quarters).debits).to have(0).items
      end

      context 'receivables' do
        it 'from outstanding debits' do
          account.debits.push debit_new
          march_quarters = Date.new(2013, 3, 25)..Date.new(2016, 3, 25)
          expect(debits = account.prepare_payment(march_quarters).debits).to have(1).item
          expect(debits.first).to eq debit_new
        end

        it 'paid debts so no debits' do
          Debit.any_instance.stub(:paid?).and_return true
          account.debits.push debit_new
          march_quarters = Date.new(2013, 3, 25)..Date.new(2016, 3, 25)
          expect(debits = account.prepare_payment(march_quarters).debits).to have(0).item
          expect(debits).to eq []
        end
      end
    end

    it '#by_human id' do
      property_create!
      expect(Account.by_human_ref(2002)).to be_present
    end
  end
end
