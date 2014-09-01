require 'rails_helper'
# rubocop: disable Style/Documentation

class PaymentEditPage
  include Capybara::DSL

  def visit_edit_page payment_id
    visit "/payments/#{payment_id}/edit"
    self
  end

  # def human_ref property
  #   fill_in 'payment_human_ref', with: property
  #   self
  # end

  def payment amount
    fill_in 'payment_credits_attributes_0_amount', with: amount
  end

  def search
    click_on 'Search'
    self
  end

  def update_payment
    click_on 'Update'
    self
  end

  def on_page? payment_id
    current_path == "/payments/#{payment_id}/edit"
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def successful?
    has_content? /successfully updated!/i
  end
end

describe Payment, type: :feature do

  let(:payment_page) { PaymentCreatePage.new }
  let(:payment_edit_page) { PaymentEditPage.new }
  before(:each) { log_in }

  it 'payment for debit - no double payments', js: true do
    charge = charge_create
    payment = payment_new credit: credit_new(amount: -88, charge_id: charge.id)
    property_create account: account_new(charge: charge,
                                         debit: debit_new,
                                         payment: payment)
    payment_edit_page.visit_edit_page(payment.id)
    payment_edit_page.payment 44.00
    payment_edit_page.update_payment
    expect(payment_edit_page).to be_successful
    expect(Credit.first.amount).to eq(-44.00)
  end

  context 'error' do
    it 'handles errors' do
      payment = payment_new credit: credit_new(amount: -88)
      property_create account: account_new(charge: charge_new,
                                           debit: debit_new,
                                           payment: payment)
      payment_edit_page.visit_edit_page(payment.id)
      payment_edit_page.payment(-100_000_000)
      payment_edit_page.update_payment
      expect(payment_edit_page).to be_errored
    end
  end
end
