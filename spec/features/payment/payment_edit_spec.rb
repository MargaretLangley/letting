require 'spec_helper'

class PaymentEditPage
  include Capybara::DSL

  def visit_edit_page payment_id
    visit "/payments/#{payment_id}/edit"
    self
  end

  # def human_ref property
  #   fill_in 'payment_human_ref', with: property
  #   self
  # end

  def payment amount
    fill_in 'payment_credits_attributes_0_amount', with: amount
  end

  def search
    click_on 'Search'
    self
  end

  def update_payment
    click_on 'update'
    self
  end

  def on_page? payment_id
    current_path == "/payments/#{payment_id}/edit"
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def successful?
    has_content? /successfully updated!/i
  end
end

describe Payment do

  let(:payment_page) { PaymentCreatePage.new }
  let(:payment_edit_page) { PaymentEditPage.new }
  before(:each) { log_in }

  it 'payment for debit - no double payments', js: true do
    pending 'works if have save_and_open_page pfft'
    payment = create_payment_to_edit
    payment_edit_page.visit_edit_page(payment.id)
    payment_edit_page.payment 44.00
    payment_edit_page.update_payment
    expect(payment_edit_page).to be_successful
  end

  context 'error' do
    it 'handles errors' do
      pending
      payment = create_payment_to_edit
      payment_edit_page.visit_edit_page(payment.id)
      payment_edit_page.payment(100_000_000)
      payment_edit_page.update_payment
      expect(payment_edit_page).to be_errored
    end
  end

  def create_payment_to_edit
    # I am using payment.create before running edit
    # This dependency makes it very fragile. Needs replacing
    (property = property_with_charge_and_unpaid_debit).save!
    payment_page.visit_new_page
    payment_page.human_ref('2002').search
    payment_page.payment 88.08
    payment_page.click_create_payment
    property.account.payments.first
  end

end
