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

  def none_delivered?
    has_content? /No invoices will be delivered./i
  end

  def none_retained?
    has_content? /No invoices will be retained./i
  end

  def actionable?
    has_content? /No property is chargeable for the range of properties/i
  end

  def excluded?
    has_content? /No properties in the range/i
  end
end

describe Invoicing, type: :feature do
  let(:invoicing_page) { InvoicingPage.new }
  before do
    log_in
    Timecop.travel Date.new(2013, 6, 1)
  end
  after  { Timecop.return }

  it 'invoices an account that matches the search' do
    cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 24)]
    account_create property: property_new(human_ref: 87, client: client_new),
                   charges: [charge_new(cycle: cycle)]
    invoice_text_create id: 1

    invoicing_page.enter

    invoicing_page.search_term('87').search
    invoicing_page.create

    expect(invoicing_page).to be_success
  end

  describe 'disabled' do
    it 'disables fieldset on first visit' do
      invoicing_page.enter
      expect(invoicing_page.form).to be_disabled
    end

    it 'enables fieldset when able to do invoicing' do
      cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 24)]
      account_create property: property_new(human_ref: 87, client: client_new),
                     charges: [charge_new(cycle: cycle)]
      invoice_text_create id: 1

      invoicing_page.enter
      invoicing_page.search_term('87').search
      expect(invoicing_page.form).to_not be_disabled
    end
  end

  describe 'errors when the property range' do
    it 'excludes all existing properties' do
      invoicing_page.enter
      invoicing_page.search_term('87').search

      expect(invoicing_page).to be_excluded
    end

    it 'does not include a chargeable property for the billing-period' do
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 25)]
      account_create property: property_new(human_ref: 87, client: client_new),
                     charges: [charge_new(cycle: cycle)]
      invoice_text_create id: 1

      invoicing_page.enter
      invoicing_page.search_term('87').search

      expect(invoicing_page).to be_actionable
    end
  end

  describe 'warns on' do
    describe 'retains mail' do
      it 'to properties that only have standing order charges.' do
        cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
        account_create property: property_new(human_ref: 9, client: client_new),
                       charges: [charge_new(payment_type: 'standing_order',
                                            cycle: cycle)]
        invoice_text_create id: 1
        invoicing_page.enter
        invoicing_page.search_term('9').search

        expect(invoicing_page).to_not be_none_retained
      end

      # The test for retaining mail is the absence of a string, a weak test.
      # This test is to bolster the weak test with one the tests for a string's
      # presence.
      #
      it 'will not retain when cash payment due' do
        cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
        account_create property: property_new(human_ref: 9, client: client_new),
                       charges: [charge_new(payment_type: 'payment',
                                            cycle: cycle)]
        invoice_text_create id: 1
        invoicing_page.enter
        invoicing_page.search_term('9').search

        expect(invoicing_page).to be_none_retained
      end
    end
  end
end
