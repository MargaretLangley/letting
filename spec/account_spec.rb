require 'spec_helper'

describe Account, type: :model do

  let(:account) { account_new  }
  it('is valid') { expect(account).to be_valid }

  context 'methods' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after { Timecop.return }

    describe 'calculated balance' do
      it 'ignores entires after date' do
        account = account_and_charge_new
        account.debits.push debit_new on_date: '25/3/2011', amount: 10.00
        account.debits.push debit_new on_date: '25/3/2012', amount: 10.00
        account.credits.push credit_new on_date: '25/4/2012', amount: 5.50
        expect(account.balance Date.new 2012, 4, 24).to \
          eq BigDecimal.new('-20.00')
      end
    end

    describe '#prepare_debits' do
      it 'generates debits when charges due' do
        account = account_and_charge_new charge_attributes: { id: 3 }
        debits = account.prepare_debits(date_when_charged)
        expect(debits.size).to eq(1)
      end

      it 'no debits when no charges due' do
        account = account_and_charge_new charge_attributes: { id: 3 }
        debits = account.prepare_debits(date_not_charged)
        expect(debits.size).to eq(0)
      end

      def date_when_charged
        Date.new(2013, 3, 25)..Date.new(2013, 3, 25)
      end

      def date_not_charged
        Date.new(2013, 3, 26)..Date.new(2013, 3, 26)
      end
    end

    describe '#prepare_credits' do
      it 'empty charges, empty credits ' do
        expect(account.prepare_credits.size).to eq(0)
      end

      it 'one charge, one credit' do
        account.charges.build charge_attributes
        expect(account.prepare_credits.size).to eq(1)
      end
    end
  end

  describe 'search' do

    account = nil
    before :each do
      account = (property_create! human_ref: 2002).account
    end

    describe '.find_by_human_ref' do
      it('handles nil') { expect(Account.find_by_human_ref(nil)).to be_nil }
      it('matching ref') do
        expect(Account.find_by_human_ref('2002')).to eq account
      end
    end

    describe '.between' do
      it('handles nil') { expect(Account.between?(nil).size).to eq 0 }
      it('matching ref') { expect(Account.between?('2002').size).to eq 1 }
      it('matching range') do
        expect(Account.between?('2000-2002').size).to eq 1
      end
      it('unlike ref range') { expect(Account.between?('4000').size).to eq 0 }
    end
  end
end
