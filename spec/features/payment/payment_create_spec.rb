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
    click_on 'payment'
    self
  end


  def empty_search?
    has_content? /No Property Selected/i
  end

  def debt_free?
    has_content? /Debt Free/i
  end

end

describe Payment do

  let(:payment_page) { PaymentCreatePage.new }
  before(:each) { log_in }


  it 'payment for debt' do
    pending 'to be continued'
    (property = property_with_charge_and_unpaid_debt).save!
    payment_page.visit_new_page
    payment_page.human_id('2002').search
    expect(payment_page).to_not be_empty_search
    expect(payment_page).to_not be_debt_free
    payment_page.payment 88.08
    payment_page.create_payment
    expect(property.account.payments[0].credits).to have(1).items
  end

  context 'error' do

    it 'unknown property' do
      payment_page.visit_new_page
      payment_page.human_id('800').search
      expect(payment_page).to be_empty_search
    end

    it 'no unpaid debts' do
      property_create!
      payment_page.visit_new_page
      payment_page.human_id('2002').search
      expect(payment_page).to be_debt_free
    end
  end

  context '#payment' do
    it 'property id invalid' do
    end
  end

  context '#payment' do
    it 'property id invalid' do
    end
  end

  context '#payment' do
    it 'Ground Rent Payment' do
    end
  end

  context '#payment' do
    it 'Monthly Payment' do
    end
  end

end
