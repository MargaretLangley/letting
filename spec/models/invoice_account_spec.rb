require 'rails_helper'

RSpec.describe InvoiceAccount, type: :model do
  it 'requires debits' do
    invoice_account = InvoiceAccount.new
    expect(invoice_account).not_to be_valid
  end

  it 'can be debited' do
    invoice_account = InvoiceAccount.new
    invoice_account.debited debits: [debit_new(charge: charge_new)]
    expect(invoice_account).to be_valid
  end

  it 'can sum' do
    invoice_account = InvoiceAccount.new
    invoice_account.debited debits: [debit_new(amount: 10, charge: charge_new),
                                     debit_new(amount: 20, charge: charge_new)]
    expect(invoice_account.sum).to eq 30
  end
end
