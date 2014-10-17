require 'rails_helper'
# rubocop: disable Style/SpaceInsideRangeLiteral

describe Account, :ledgers, type: :model do
  it('is valid') { expect(account_new).to be_valid }

  context 'methods' do
    before { Timecop.travel Date.new(2013, 1, 31) }
    after { Timecop.return }

    describe '#invoice' do

      describe 'arrears' do
        it 'adds debits before billing period' do
          debit = debit_new amount: 30, on_date: Date.new(2013, 3, 4)
          account = account_new debits: [debit]
          invoice = account.invoice billing_period: Date.new(2013, 3, 5)..
                                                    Date.new(2013, 5, 5)
          expect(invoice[:arrears]).to eq(30)
        end

        it 'subtracts credits before billing period' do
          credit = credit_new amount: -30, on_date: Date.new(2013, 3, 4)
          account = account_new credits: [credit]
          invoice = account.invoice billing_period: Date.new(2013, 3, 5)..
                                                    Date.new(2013, 5, 5)
          expect(invoice[:arrears]).to eq(-30)
        end

        it 'smoke test' do
          debit_1 = debit_new amount: 10, on_date: Date.new(2012, 3, 4)
          debit_2 = debit_new amount: 10, on_date: Date.new(2013, 3, 4)
          credit_1 = credit_new amount: -30, on_date: Date.new(2012, 3, 4)
          credit_2 = credit_new amount: -30, on_date: Date.new(2013, 3, 4)
          account = account_new credits: [credit_1, credit_2],
                                debits: [debit_1, debit_2]
          invoice = account.invoice billing_period: Date.new(2013, 3, 5)..
                                                    Date.new(2013, 5, 5)
          expect(invoice[:arrears]).to eq(-40)
        end
      end

      describe 'total_arrears' do
        it 'adds debits before billing period' do
          debit = debit_new amount: 30, on_date: Date.new(2013, 3, 4)
          account = account_new debits: [debit]
          invoice = account.invoice billing_period: Date.new(2013, 3, 5)..
                                                    Date.new(2013, 5, 5)
          expect(invoice[:total_arrears]).to eq(30)
        end

        it 'adds debits during the billing period' do
          account = account_new charge: charge_new(amount: 43, cycle: \
            cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
          invoice = account.invoice billing_period: Date.new(2013, 3, 5)..
                                                    Date.new(2013, 3, 5)
          expect(invoice[:total_arrears]).to eq(43)
        end

        it 'totals debits before and during billing period' do
          account = account_new \
            debits: [debit_new(amount: 30, on_date: Date.new(2013, 3, 4))],
            charge: charge_new(amount: 43, cycle: \
              cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
          invoice = account.invoice billing_period: Date.new(2013, 3, 5)..
                                                    Date.new(2013, 3, 5)
          expect(invoice[:total_arrears]).to eq(73)
        end
      end

      it 'produces debits if charge is due' do
        account = account_new charge: charge_new(cycle: \
          cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        invoice = account.invoice billing_period: Date.new(2013, 3, 5)..
                                                  Date.new(2013, 3, 5)
        expect(invoice[:debits].size).to eq(1)
      end

      it 'no debits when charge is not due' do
        account = account_new charge: charge_new(cycle: \
          cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        invoice = account.invoice billing_period: Date.new(2013, 3, 6)..
                                                  Date.new(2013, 3, 6)
        expect(invoice[:debits].size).to eq(0)
      end
    end

    describe '#invoice?' do
      it 'returns true if debits would be made' do
        account = account_new charge: charge_new(cycle: \
          cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        expect(account.invoice? billing_period: Date.new(2013, 3, 5)..
                                                Date.new(2013, 3, 5))
          .to be true
      end

      it 'returns false if debits would not be made' do
        account = account_new charge: charge_new(cycle: \
          cycle_create(due_ons: [DueOn.new(day: 5, month: 3)]))
        expect(account.invoice? billing_period: Date.new(2013, 3, 6)..
                                                Date.new(2013, 3, 6))
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
