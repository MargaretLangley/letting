require 'spec_helper'

describe AccountDecorator do

  let(:account) do
    account = account_and_charge_new
    account.debits.push debit_new id: nil
    account.debits.push debit_new id: nil, on_date: '25/3/2012'
    account.credits.push credit_new
    account.save!
    AccountDecorator.new account
  end

  context 'items' do

    it 'sorted on date' do
      expect(account.items.first.on_date).to eq Date.new 2012, 3, 25
      expect(account.items.last.on_date).to eq Date.new 2013, 4, 30
    end

  end

  context 'abbrev_items' do
    let(:account) do
      account = account_and_charge_new
      account.debits.push debit_new id: nil, on_date: '25/3/2011'
      account.debits.push debit_new id: nil, on_date: '25/3/2012'
      account.credits.push credit_new id: nil, on_date: '25/4/2012'
      account.credits.push credit_new
      account.save!
      AccountDecorator.new account
    end

    it 'abbrev_items' do
      expect(account.abbrev_items.first.balance).to eq 88.08
      expect(account.abbrev_items.last.on_date).to eq Date.new 2013, 4, 30
    end
  end

end