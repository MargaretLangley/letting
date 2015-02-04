require 'rails_helper'
# rubocop: disable Style/Documentation

class PaymentIndexPage
  include Capybara::DSL

  def load
    visit '/payments'
    self
  end

  def search search_string = ''
    fill_in 'payment_search', with: search_string
    click_on 'Payment Search'
    self
  end

  def delete
    click_on 'Delete'
    self
  end

  def without_payment?
    has_no_content? /Mr W. G. Grace/i
  end

  def having_payment?
    has_content? /Mr W. G. Grace/i
  end

  def deleted?
    has_content? /deleted!/i
  end
end

describe 'Payment#index', :ledgers, type: :feature do
  let(:payment_index) { PaymentIndexPage.new }
  before { log_in }

  it 'all' do
    property_create account: account_new(payment: payment_new)
    payment_index.load
    expect(payment_index).to be_having_payment
  end

  it '#destroys a property' do
    property_create account: account_new(payment: payment_new)
    payment_index.load
    expect { payment_index.delete }.to change(Payment, :count).by(-1)
    expect(payment_index).to be_deleted
  end
end
