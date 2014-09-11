require 'rails_helper'

describe Payment, :payment, type: :feature do

  let(:payment_page) { PaymentPage.new }
  before(:each) { log_in }

  it 'payment for debit', js: true do
    property_create account: account_new(charge: charge_new, debit: debit_new)
    payment_page.visit_new
    payment_page.human_ref('2002').search
    expect(payment_page).to_not be_empty_search
    property_receivables?
    expect(payment_page.payment).to eq('88.08')
    payment_page.payment = 88.08
    payment_page.pay
    payment_is_created
  end

  describe 'error' do

    it 'searched property unknown' do
      skip 'currently it does full text search on properties'
      # expects [data-role="unknown-property"]
      payment_page.visit_new

      payment_page.human_ref('800').search
      save_and_open_page
      expect(payment_page).to be_empty_search
    end

    it 'displays form errors' do
      property_create human_ref: '2002',
                      account: account_new(charge: charge_new, debit: debit_new)
      payment_page.visit_new

      payment_page.human_ref('2002').search
      payment_page.payment = 100_000_000
      payment_page.pay
      expect(payment_page).to be_errored
      payment_has_been_negated?
    end
  end

  def payment_is_created
    expect(payment_page).to be_successful
  end

  def property_receivables?
    expect(payment_page).to be_receivables
  end

  def payment_has_been_negated?
     expect(payment_page.payment.to_i).to be > 0
  end
end
