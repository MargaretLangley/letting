require 'rails_helper'

describe Payment, :ledgers, :payment, type: :feature do
  let(:payment_page) { PaymentPage.new }
  before(:each) { log_in }

  it 'opens payment page as expected' do
    account_create property: property_create(human_ref: 2003),
                   charges: [charge_new(debits: [debit_new(amount: 20.05)])]

    payment_page.visit_new
    payment_page.human_ref('2003').search

    expect(payment_page).to be_populated_search
    expect(payment_page).to be_receivables # receivables eq debts
  end

  it 'payment for debit', js: true do
    account_create property: property_create(human_ref: 2003),
                   charges: [charge_new(debits: [debit_new(amount: 20.05)])]

    payment_page.visit_new
    payment_page.human_ref('2003').search

    expect(payment_page.credit).to eq 20.05
    payment_page.credit = 15.05
    expect(payment_page.payment).to eq 15.05
    payment_page.pay

    expect(payment_page).to be_successful
    expect(Credit.first.amount.to_d).to eq(-15.05)
    expect(Payment.first.amount.to_d).to eq(-15.05)
  end

  it 'displays form errors' do
    account_create property: property_create(human_ref: 2003),
                   charges: [charge_new(debits: [debit_new])]

    payment_page.visit_new
    payment_page.human_ref('2003').search

    payment_page.credit = 100_000_000
    payment_page.pay
    expect(payment_page).to be_errored
    credit_negated?
  end

  def credit_negated?
    expect(payment_page.credit.to_i).to be > 0
  end
end
