require 'rails_helper'

describe Account, :ledgers, type: :model do
  it('is valid') { expect(account_new).to be_valid }

  context 'methods' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after { Timecop.return }

    describe '#make_debits' do
      it 'produces debits if charge is due' do
        account = account_new charge: charge_new(charge_cycle: \
          charge_cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        debits = account.make_debits Date.new(2013, 3, 5)..Date.new(2013, 3, 5)
        expect(debits.size).to eq(1)
      end

      it 'no debits when charge is not due' do
        account = account_new charge: charge_new(charge_cycle: \
          charge_cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        debits = account.make_debits Date.new(2013, 3, 6)..Date.new(2013, 3, 6)
        expect(debits.size).to eq(0)
      end
    end

    describe '#make_debits?' do
      it 'returns true if debits would be made' do
        account = account_new charge: charge_new(charge_cycle: \
          charge_cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        expect(account.make_debits? Date.new(2013, 3, 5)..Date.new(2013, 3, 5))
          .to be true
      end

      it 'returns false if debits would not be made' do
        account = account_new charge: charge_new(charge_cycle: \
          charge_cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        expect(account.make_debits? Date.new(2013, 3, 6)..Date.new(2013, 3, 6))
          .to be false
      end
    end

    describe '#make_credits' do
      it 'empty charges, empty credits ' do
        expect(account_new.make_credits.size).to eq(0)
      end

      it 'one charge, one credit' do
        (account = account_new).charges << charge_new
        expect(account.make_credits.size).to eq(1)
      end

      it 'produces negative amounted credits' do
        (account = account_new).charges << charge_new
        expect(account.make_credits.first.amount).to be < 0
      end
    end
  end

  describe '#balance' do
    it 'calculates balance to_date' do
      account = account_new
      account.debits.push debit_new on_date: '25/3/2011', amount: 10.00
      account.credits.push credit_new on_date: '25/4/2012', amount: -11.00
      expect(account.balance to_date: Date.new(2013, 1, 1)).to eq(-1.00)
    end

    it 'ignores entries after date' do
      account = account_new
      account.debits.push debit_new on_date: '25/3/2011', amount: 10.00
      account.credits.push credit_new on_date: '25/4/2012', amount: -5.50
      expect(account.balance to_date: Date.new(2012, 4, 24)).to eq 10.00
    end
  end

  describe 'search' do
    before { property_create human_ref: 5, account: account_new }

    describe '.find_by_human_ref' do
      it('handles nil') { expect(Account.find_by_human_ref(nil)).to be_nil }
      it('matching ref') do
        expect(Account.find_by_human_ref('5')).to eq Account.first
      end
    end

    describe '.between' do
      it('handles nil') { expect(Account.between?(nil).size).to eq 0 }
      it('matching ref') { expect(Account.between?('5').size).to eq 1 }
      it('matching range') { expect(Account.between?('5-5').size).to eq 1 }
      it('unlike ref range') { expect(Account.between?('4000').size).to eq 0 }
    end
  end
end
