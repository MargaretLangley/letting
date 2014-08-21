require 'rails_helper'
# rubocop: disable Style/Documentation

class PaymentIndexPage
  include Capybara::DSL

  def visit_page
    visit '/payments'
    self
  end

  def search search_string = ''
    fill_in 'search', with: search_string
    click_on 'Search'
    self
  end

  def delete
    click_on 'Delete'
    self
  end

  def having_payment?
    has_content? /Mr W. G. Grace/i
  end

  def deleted?
    has_content? /payment successfully deleted!/i
  end
end

describe 'Payment index', type: :feature do

  let(:payment_index) { PaymentIndexPage.new }
  before(:each) { log_in }

  it 'all' do
    property = property_create
    Payment.create! payment_attributes account_id: property
           .account.id
    payment_index.visit_page
    expect(payment_index).to be_having_payment
  end

  it 'search' do
    skip 'search'
    property = property_create
    Payment.create! payment_attributes account_id: property.account.id
    payment_index.visit_page
    payment_index.search Date.current.to_s
    expect(payment_index).to be_having_payment
  end

  it 'failed search' do
    skip 'search'
    property = property_create
    Payment.create! payment_attributes account_id: property.account.id
    payment_index.visit_page
    payment_index.search '2003'
    expect(payment_index).to_not be_having_payment
  end

  it '#destroys a property' do
    property = property_create
    Payment.create! payment_attributes account_id: property.account.id
    payment_index.visit_page
    expect { payment_index.delete }.to change(Payment, :count).by(-1)
    expect(payment_index).to be_deleted
  end
end
