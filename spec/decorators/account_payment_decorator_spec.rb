require 'spec_helper'

describe AccountPaymentDecorator do

    context '#prepare_for_form' do
      it 'creates credits with amount defaulting from debit' do
        account = account_new
        expect(account.credits.select(&:new_record?)).to have(0).item
        account.add_debit debit_attributes
        account_dec = AccountPaymentDecorator.new account
        account_dec.prepare_for_form
        expect(account_dec.credits_for_unpaid_debits).to have(1).item
        expect(account_dec.credits.first.amount).to eq debit_attributes[:amount]
      end

      it 'ignored paid' do
        # credit has associated debit
        account = account_new
        account.debits << debit_new
        account.save!
        account.credits << credit_new(debit: account.debits.first)
        account.save!
        expect(account.debits).to have(1).item
        account_dec = AccountPaymentDecorator.new account
        account_dec.prepare_for_form
        expect(account_dec.credits_for_unpaid_debits).to have(0).item
      end
    end


  context '#clear_up_form' do
    let(:account) do
      account = account_and_charge_new
      account.debits.push debit_new
      account.debits.push debit_new on_date: '25/9/2013'
      account.credits.push credit_new
      account.save!
      AccountPaymentDecorator.new account
    end


    it 'keeps credits with postive amount' do
      account.add_debit debit_attributes
      account.prepare_for_form
      account.credits.first.amount = 1
      account.clear_up_form
      expect(account.credits.first).to_not be_marked_for_destruction
    end

    it 'removes credits with 0 amount' do
      account.add_debit debit_attributes
      account.prepare_for_form
      account.credits.first.amount = 0
      account.clear_up_form
      expect(account.credits.first).to be_marked_for_destruction
    end
  end
end