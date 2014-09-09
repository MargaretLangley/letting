require 'rails_helper'

describe Payment, type: :feature do

  let(:payment_page) { PaymentCreatePage.new }
  before(:each) { log_in }

  it 'payment for debit', js: true do
    property_create account: account_new(charge: charge_new, debit: debit_new)
    payment_page.visit_new_page
    payment_page.human_ref('2002').search
    a_property_is_found
    property_receivables?
    expect(payment_page.payment).to eq('88.08')
    payment_page.payment = 88.08
    payment_page.click_create_payment
    payment_is_created
  end

  context 'error' do

    it 'searched property unknown' do
      skip 'currently it does full text search on properties'
      # expects [data-role="unknown-property"]
      payment_page.visit_new_page

      payment_page.human_ref('800').search
      save_and_open_page
      no_property_found
    end

    it 'displays form errors' do
      property_create human_ref: '2002',
                      account: account_new(charge: charge_new, debit: debit_new)
      payment_page.visit_new_page

      payment_page.human_ref('2002').search
      payment_page.payment = 100_000_000
      payment_page.click_create_payment
      expect(payment_page).to be_errored
    end
  end

  def a_property_is_found
    expect(payment_page).to_not be_empty_search
  end

  def no_property_found
    expect(payment_page).to be_empty_search
  end

  def payment_is_created
    expect(payment_page).to be_successful
  end

  def property_receivables?
    expect(payment_page).to be_receivables
  end

end
