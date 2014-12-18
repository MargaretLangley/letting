require 'rails_helper'

#####
#
# InvoicingPage
#
# Encapsulates the page so tests can work at a higher abstraction than capybara
# will allow.
#
class InvoicingPage
  include Capybara::DSL

  def enter
    visit '/invoicings/new'
    self
  end

  def search_term term
    fill_in 'search_terms', with: term
    self
  end

  def search
    click_on 'Search'
    self
  end

  def choose_dates
    click_on 'or choose dates'
    self
  end

  def form
    # fieldset id
    find('#invoicing')
  end

  def create
    click_on 'Create Invoicing'
    self
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def success?
    has_content? /created|updated/i
  end
end

describe Invoicing, type: :feature do
  let(:invoicing_page) { InvoicingPage.new }
  before do
    log_in
    Timecop.travel Date.new(2013, 6, 1)
  end
  after  { Timecop.return }

  describe 'disabled' do
    it 'disables fieldset on first visit' do
      invoicing_page.enter
      expect(invoicing_page.form).to be_disabled
    end

    it 'enables fieldset when able to do invoicing' do
      cycle = cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
      account_create property: property_new(human_ref: 87, client: client_new),
                     charges: [charge_new(cycle: cycle)]
      invoice_text_create id: 1

      invoicing_page.enter
      invoicing_page.search_term('87').search
      expect(invoicing_page.form).to_not be_disabled
    end
  end

  it 'invoices an account that matches the search' do
    cycle = cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
    account_create property: property_new(human_ref: 87, client: client_new),
                   charges: [charge_new(cycle: cycle)]
    invoice_text_create id: 1

    invoicing_page.enter

    invoicing_page.search_term('87').search
    invoicing_page.create
    expect(invoicing_page).to be_success
  end

  it 'messages help when no invoicing found' do
    cycle = cycle_new due_ons: [DueOn.new(day: 25, month: 5)]
    account_create property: property_new(human_ref: 87, client: client_new),
                   charges: [charge_new(cycle: cycle)]
    invoice_text_create id: 1

    invoicing_page.enter
    invoicing_page.search_term('87').search
    expect(invoicing_page.has_content? /Upcoming Charges/).to be true
  end
end
