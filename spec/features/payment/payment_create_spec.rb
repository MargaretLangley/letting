require 'spec_helper'

class PaymentCreatePage
  include Capybara::DSL

  def visit_new_page
    visit '/payments/new'
    self
  end

  def human_id property
    fill_in 'payment_human_id', with: property
    self
  end

  def payment amount
    fill_in 'payment_credits_attributes_0_amount', with: amount
  end

  def search
    click_on 'Search'
    self
  end

  def create_payment
    click_on 'pay total'
    self
  end

  def on_page?
    current_path == '/payments/new'
  end

  def empty_search?
    has_content? /To book a payment against a property you need/i
  end

  def debit_free?
    has_content? /Property has no outstanding debts/i
  end

  def errored?
    has_content? /The payment could not be saved./i
  end

  def successful?
    has_content? /Payment successfully created/i
  end

end

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
      pending
      property_with_charge_and_unpaid_debit.save!
      payment_page.visit_new_page
      payment_page.human_id('2002').search
      payment_page.payment(-10)
      payment_page.create_payment
      expect(payment_page).to be_errored
    end
  end

end
