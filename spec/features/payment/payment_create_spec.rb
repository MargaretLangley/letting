require 'spec_helper'

class PaymentCreatePage
  include Capybara::DSL

  def visit_new_page
    visit '/payments/new'
    self
  end

end

describe Payment do

  let(:payment_page) { PaymentCreatePage.new }
  before(:each) { log_in }

  it 'payment for debt' do
    pending 'Next Feature Test'
    account_and_debt.save!
    payment_page.visit_new_page

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
