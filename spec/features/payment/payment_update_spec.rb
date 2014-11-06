require 'rails_helper'
# rubocop: disable Style/Documentation

describe Payment, :ledgers, :payment, type: :feature do

  let(:payment_page) { PaymentPage.new }
  before(:each) { log_in }

  it 'payment for debit - no double payments', js: true do
    charge = charge_create debits: [debit_new]
    payment = payment_new credit: credit_new(amount: -88, charge_id: charge.id)
    property_create account: account_new(payment: payment, charges: [charge])

    payment_page.visit_edit payment.id
    payment_page.payment = 44.00
    payment_page.pay
    expect(payment_page).to be_successful
    payment_page.visit_edit payment.id
    expect(payment_page.payment).to eq('44.00')
  end

  context 'error' do
    it 'displays form errors' do
      charge = charge_new(debits: [debit_new])
      payment = payment_new credit: credit_new(charge: charge, amount: -88)
      property_create account: account_new(payment: payment, charges: [charge])

      payment_page.visit_edit payment.id
      payment_page.payment = -100_000_000
      payment_page.pay
      expect(payment_page).to be_errored
      payment_has_been_negated?
    end

    def payment_has_been_negated?
      expect(payment_page.payment.to_i).to be > 0
    end
  end
end
