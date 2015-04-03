require 'rails_helper'

describe Payments do
  describe 'methods' do
    it 'to_a' do
      payment1 = payment_create(account: account_new, amount: 10)
      payment2 = payment_create(account: account_new, amount: 20)
      payments = Payments.new [payment1, payment2]
      expect(payments.to_a).to eq [payment1, payment2]
    end

    it 'sum' do
      # payments will be created with negative amounts
      payment1 = payment_create(account: account_new, amount: 10)
      payment2 = payment_create(account: account_new, amount: 20)
      payments = Payments.new [payment1, payment2]
      expect(payments.sum).to eq 30
    end
  end
end
