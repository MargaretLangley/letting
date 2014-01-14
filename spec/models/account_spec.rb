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
      it 'empty charges, empty credits ' do
        expect(account.prepare_credits).to have(0).items
      end

      it 'one charge, one credit' do
        account.charges.build charge_attributes
        expect(account.prepare_credits).to have(1).item
      end
    end

    it '#by_human id' do
      property_create!
      expect(Account.by_human_ref(2002)).to be_present
    end
  end
end
