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

  it 'Not destroyed when associated invoice destroyed' do
    template_create id: 1
    (transaction = InvoiceAccount.new)
      .debited(debits: [debit_new(charge: charge_new)])

    (invoice = Invoice.new)
      .prepare invoice_date: '2014-06-30',
               property: { property_ref: 20,
                           property_address: 'Road',
                           billing_address: 'Road',
                           client_address: 'Road' },
               billing: { arrears: 0, transaction:  transaction }
    invoice.save!
    invoice.destroy
    expect(Invoice.count).to eq 0
    expect(InvoiceAccount.count).to eq 1
  end
end
