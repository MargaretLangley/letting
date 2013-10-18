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

  def search
    click_on 'Search'
    self
  end

  def empty_search?
    has_content? /No Property Selected/i
  end

end

describe Payment do

  let(:payment_page) { PaymentCreatePage.new }
  before(:each) { log_in }

  it 'handles unknown property' do
    payment_page.visit_new_page
    payment_page.human_id('800').search
    expect(payment_page).to be_empty_search
  end

  it 'payment for debt' do
    property_with_unpaid_debt.save!
    payment_page.visit_new_page
    payment_page.human_id('2002').search
    expect(payment_page).to_not be_empty_search
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
