require 'rails_helper'
# rubocop: disable Style/Documentation

class PaymentIndexPage
  include Capybara::DSL

  def enter
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

  def having_payment?
    has_content? /Mr W. G. Grace/i
  end

  def deleted?
    has_content? /successfully deleted!/i
  end
end

describe 'Payment index', :ledgers, type: :feature do

  let(:payment_index) { PaymentIndexPage.new }
  before(:each) { log_in }

  it 'all' do
    property_create account: account_new(payment: payment_new)
    payment_index.enter
    expect(payment_index).to be_having_payment
  end

  describe 'payment search' do
    it 'matches transactions on the same day' do
      payment = payment_new(booked_on: '30/4/2013 01:00:00 +0100')
      property_create account: account_new(payment: payment)
      payment_index.enter
      payment_index.search Date.new(2013, 4, 30).to_s
      expect(payment_index).to be_having_payment
    end

    it 'misses transactions on a different day' do
      payment = payment_new(booked_on: '2014/01/25 01:00:00 +1000')
      property_create account: account_new(payment: payment)
      payment_index.enter
      payment_index.search '2000/01/01'
      expect(payment_index).to_not be_having_payment
    end
  end

  it '#destroys a property' do
    property_create account: account_new(payment: payment_new)
    payment_index.enter
    expect { payment_index.delete }.to change(Payment, :count).by(-1)
    expect(payment_index).to be_deleted
  end
end
