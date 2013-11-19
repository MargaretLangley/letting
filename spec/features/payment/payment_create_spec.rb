require 'spec_helper'

describe Payment do

  let(:payment_page) { PaymentCreatePage.new }
  before(:each) { log_in }

  it 'payment for debit' do
    property_with_charge_and_unpaid_debit.save!
    payment_page.visit_new_page

    payment_page.human_ref('2002').search
    a_property_is_found
    property_has_unpaid_debits
    payment_page.payment 88.08
    payment_page.click_create_payment
    payment_is_created
  end

  it 'no debit, show advanced payment' do
    property_with_charge_create!
    payment_page.visit_new_page

    payment_page.human_ref('2002').search
    a_property_is_found
    property_has_no_unpaid_debits
    property_has_credits_in_advance
    payment_page.payment 88.08
    payment_page.click_create_payment
    payment_is_created
  end


  context 'error' do

    it 'searched property unknown' do
      payment_page.visit_new_page

      payment_page.human_ref('800').search

      no_property_found
    end

    it 'handles errors' do
      property_with_charge_and_unpaid_debit.save!
      payment_page.visit_new_page

      payment_page.human_ref('2002').search
      payment_page.payment(100_000_000)
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

  def property_has_credits_in_advance
    expect(payment_page).to be_has_credits_in_advance
  end

  def property_has_unpaid_debits
    expect(payment_page).to be_has_credits_with_debits
  end

  def property_has_no_unpaid_debits
    expect(payment_page).to_not be_has_credits_with_debits
  end

end
