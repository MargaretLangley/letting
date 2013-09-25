require 'spec_helper'

describe Account do

  let(:account) { Account.create! id: 1, property_id: 1  }

  it 'is valid' do
    expect(account).to be_valid
  end

  it 'makes payments' do
    expect(account.payment payment_attributes ).to be_valid
  end

  it 'makes debts' do
    expect(account.add_debt debt_attributes ).to be_valid
  end

  it 'lists unpaid debts' do
    debt1 = account.add_debt debt_attributes
    debt2 = account.add_debt debt_attributes charge_id: 2
    account.save!
    account.payment payment_attributes debt_id: debt1.id
    account.save!
    expect(Debt.all.to_a).to eq [debt1, debt2]
    expect(account.unpaid_debts).to eq [ debt2 ]
  end

  it 'returns the payments most recent first' do
    payments = []
    3.times { payments << account.payment(payment_attributes) }
    account.save!
    expect(Payment.all.to_a).to eq payments
    expect(Account.lastest_payments(2)).to eq payments.reverse[0..1]
  end

  context 'charges' do

    it 'has no charges' do
      expect(account.charges).to have_exactly(0).items
    end

    it 'has charges' do
      expect(account.charges).to eq []
    end

    # Tests that relationship exists
    it 'adds a new charge' do
      account.charges.build charge_type: 'ground_rent', \
        due_in: 'advance', amount: '50.50', account_id: account.id
      expect(account.charges.first.charge_type).to eq 'ground_rent'
    end

    it 'generates debts for charges' do
      charge = account.charges.build id: 1, charge_type: 'ground_rent', \
        due_in: 'advance', amount: '50.50', account_id: account.id
      charge.due_ons.build charge_id: 1, day: 15, month: 6

      debts = account.generate_debts_for Date.new(2013,6,1)..Date.new(2013,6,30)
      expect(debts.first).to eq Debt.new account_id: 1, \
                                         charge_id: charge.id,  \
                                         on_date: '2013-06-15', \
                                         amount: BigDecimal.new(50.50,8)
    end

  end


end
