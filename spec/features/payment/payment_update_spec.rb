require 'rails_helper'
# rubocop: disable Style/Documentation

describe Payment, :ledgers, :payment, type: :feature do
  let(:payment_page) { PaymentPage.new }
  before(:each) { log_in }

  it 'editing original payment - no double payments', js: true do
    charge = charge_create debits: [debit_new(amount: 30)]
    payment = payment_new credit: credit_new(amount: 30, charge_id: charge.id)
    account_create payment: payment,
                   charges: [charge],
                   property: property_create(human_ref: 2003)

    # editing the above original payment
    payment_page.visit_edit payment.id
    payment_page.credit = 20.00
    payment_page.pay
    expect(payment_page).to be_successful
    expect(Credit.first.amount).to eq(20.00)
  end

  it 'displays form errors' do
    charge = charge_create debits: [debit_new(amount: 30)]
    payment = payment_new credit: credit_new(amount: 30, charge_id: charge.id)
    account_create payment: payment,
                   charges: [charge],
                   property: property_create(human_ref: 2003)

    payment_page.visit_edit payment.id
    payment_page.credit = 100_000_000
    payment_page.pay
    expect(payment_page).to be_errored
  end
end
