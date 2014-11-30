require 'rails_helper'

RSpec.describe DebitsTransaction, type: :model do
  it 'requires debits' do
    debits_transaction = DebitsTransaction.new
    expect(debits_transaction).not_to be_valid
  end

  it 'can be debited' do
    debits_transaction = DebitsTransaction.new
    debits_transaction.debited debits: [debit_new(charge: charge_new)]
    expect(debits_transaction).to be_valid
  end

  it 'can sum' do
    debits_transaction = DebitsTransaction.new
    debits_transaction
      .debited debits: [debit_new(amount: 10, charge: charge_new),
                        debit_new(amount: 20, charge: charge_new)]
    expect(debits_transaction.sum).to eq 30
  end
end
