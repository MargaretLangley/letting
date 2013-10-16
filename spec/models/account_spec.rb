require 'spec_helper'

describe Account do

  let(:account) { account_new  }
  it('is valid') { expect(account).to be_valid }

  context 'assocations' do
    context 'has many' do
      it('charges')  { expect(account).to respond_to(:charges) }
      it('debts')    { expect(account).to respond_to(:debts) }
      it('credits')  { expect(account).to respond_to(:credits) }
    end
    context 'belongs to' do
      it('property') { expect(account).to respond_to(:property) }
    end
  end

  context 'chargeables' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after { Timecop.return }

    it 'for charges between dates' do
      account = account_and_charge_new charge_attributes: { id: 3 }
      chargeable = account.chargeables_between(dates_in_march).first
      expect(chargeable.account_id).to eq 1
      expect(chargeable.charge_id).to eq 3
      expect(chargeable.on_date).to eq Date.new(2013, 3, 25)
      expect(chargeable.amount).to eq 88.08
    end

    it 'not if already debts' do
      account = account_and_charge_new charge_attributes: { id: 3 }
      account.add_debt debt_attributes
      expect(account.chargeables_between(dates_in_march)).to eq []
    end

    def dates_in_march
      Date.new(2013, 3, 1)..Date.new(2013, 3, 31)
    end
  end

  it 'makes credit' do
    expect(account.add_credit payment_attributes).to be_valid
  end

  it 'makes debts' do
    expect(account.add_debt debt_attributes).to be_valid
  end

  it 'lists unpaid debts' do
    debt1 = account.add_debt debt_attributes
    debt2 = account.add_debt debt_attributes charge_id: 2
    account.save!
    account.add_credit credit_attributes debt_id: debt1.id
    account.save!
    expect(Debt.all.to_a).to eq [debt1, debt2]
    expect(account.unpaid_debts).to eq [debt2]
  end

  # it 'returns the credits most recent first' do
  #   pay?ments = []
  #   3.times { pay?ments << account.add_credit(credit_attributes) }
  #   account.save!
  #   expect(Payment.all.to_a).to eq pay?ments
  #   expect(Account.lastest_payments(2)).to eq pay?ments.reverse[0..1]
  # end
end
