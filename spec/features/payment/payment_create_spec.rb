require 'spec_helper'


describe Payment do

  let(:payment_page) { PaymentCreatePage.new }
  before(:each) { log_in }

  it 'payment for debit - no double payments' do
    property_with_charge_and_unpaid_debit.save!
    payment_page.visit_new_page
    payment_page.human_id('2002').search
    expect(payment_page).to_not be_empty_search
    expect(payment_page).to_not be_debit_free
    payment_page.payment 88.08
    payment_page.create_payment
    expect(payment_page).to be_successful
    expect(payment_page).to be_on_page

    # double payment
    payment_page.human_id('2002').search
    expect(payment_page).to be_debit_free
  end

  context 'error' do

    it 'searched property unknown' do
      payment_page.visit_new_page
      payment_page.human_id('800').search
      expect(payment_page).to be_empty_search
    end

    it 'property has no unpaid debits' do
      property_create!
      payment_page.visit_new_page
      payment_page.human_id('2002').search
      expect(payment_page).to be_debit_free
    end

    it 'handles errors' do
      property_with_charge_and_unpaid_debit.save!
      payment_page.visit_new_page
      payment_page.human_id('2002').search
      payment_page.payment(100_000_000)
      payment_page.create_payment
      expect(payment_page).to be_errored
    end
  end

end
