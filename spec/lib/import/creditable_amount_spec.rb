require 'spec_helper'
require_relative '../../../lib/import/creditable_amount'

module DB
  describe CreditableAmount do

    let(:amount) { CreditableAmount.new 0 }

    it 'initializes to set amount' do
      expect(amount.balance).to eq 0
    end

    it 'debits increases creditable amount' do
      amount.deposit(10).deposit(10)
      expect(amount.balance).to eq 20
    end

    it 'credits decrease' do
      amount.deposit(10).deposit(10)
      amount.withdraw 10
      expect(amount.balance).to eq 10
    end

    it 'withdraw more than has raises error' do
      expect { amount.withdraw 10 }.to raise_error DB::CreditNegativeError
    end

    context 'max_withdrawal' do
      it 'can not withdrawal more than it has' do
        expect(amount.max_withdrawal 30).to eq 0
      end
    end

  end
end