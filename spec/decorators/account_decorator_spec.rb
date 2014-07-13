require 'spec_helper'

describe AccountDecorator do
  before { Timecop.travel(Date.new(2013, 1, 31)) }
  after { Timecop.return }

  let(:account) do
    account = account_and_charge_new
    account.debits.push debit_new
    account.debits.push debit_new on_date: '25/9/2013'
    account.credits.push credit_new
    account.save!
    AccountDecorator.new account
  end

  context 'sorted' do

    it 'items' do
      expect(account.items[0].on_date).to eq Date.new 2013, 3, 25
      expect(account.items[1].on_date).to eq Date.new 2013, 4, 30
      expect(account.items[2].on_date).to eq Date.new 2013, 9, 25
    end

    it 'items-balance' do
      account = AccountDecorator.new account_and_charge_new
      account.debits.push debit_new on_date: '25/9/2012', amount: 10.00
      account.debits.push debit_new on_date: '25/9/2013', amount: 10.00
      account.credits.push credit_new on_date: '25/9/2014', amount: 15.00
      expect(account.items[0].balance).to eq 10.00
      expect(account.items[1].balance).to eq 20.00
      expect(account.items[2].balance).to eq  5.00
    end

    it 'abbrev-items' do
      expect(account.abbrev_items[0].on_date).to eq Date.new 2013, 1, 1
      expect(account.abbrev_items[1].on_date).to eq Date.new 2013, 3, 25
      expect(account.abbrev_items[2].on_date).to eq Date.new 2013, 4, 30
      expect(account.abbrev_items[3].on_date).to eq Date.new 2013, 9, 25
    end

  end

  context 'zero balance' do
    let(:account) do
      account = account_and_charge_new
      account.save!
      AccountDecorator.new account
    end

    it 'abbrev_items' do
      expect(account.abbrev_items.first.balance).to eq 0.0
    end
  end

  context 'calculated balance' do
    it 'abbrev_items' do
      account = account_and_charge_new
      account.debits.push debit_new   on_date: '25/3/2011', amount: 10.00
      account.debits.push debit_new   on_date: '25/3/2012', amount: 10.00
      account.credits.push credit_new on_date: '25/4/2012', amount: 5.50
      account.save!
      dec = AccountDecorator.new account

      expect(dec.abbrev_items.first.balance).to eq 14.50
    end
  end
end
