require 'spec_helper'

describe AccountDecorator do

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
    let(:account) do
      account = account_and_charge_new
      account.debits.push debit_new on_date: '25/3/2011'
      account.debits.push debit_new on_date: '25/3/2012'
      account.credits.push credit_new on_date: '25/4/2012'
      account.save!
      AccountDecorator.new account
    end

    it 'abbrev_items' do
      expect(account.abbrev_items.first.balance).to eq 88.08
    end
  end
end