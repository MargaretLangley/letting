require 'rails_helper'

describe 'Invoicing#create', type: :feature do
  let(:invoicing_page) { InvoicingPage.new }
  before do
    log_in
    invoice_text_create id: 1
  end

  it 'invoices an account that matches the search' do
    Timecop.travel '2013-6-1'

    create_account human_ref: 87,
                   cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
    invoicing_page.load

    invoicing_page.search_term('87').create

    expect(invoicing_page).to be_success

    Timecop.return
  end

  describe 'invoice_date' do
    it 'defaults to today' do
      Timecop.travel '2013-6-1'

      create_account human_ref: 87,
                     cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
      invoicing_page.load

      expect(invoicing_page.invoice_date).to eq Time.zone.today.to_s

      Timecop.return
    end

    it 'saves date between invoicings' do
      Timecop.travel '2013-6-1'

      create_account human_ref: 87,
                     cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
      invoicing_page.load

      invoicing_page.invoice_date = Time.zone.tomorrow.to_s

      invoicing_page.search_term('87').create

      invoicing_page.load

      expect(invoicing_page.invoice_date).to eq Time.zone.tomorrow.to_s

      Timecop.return
    end

    it 'saves date when it errors' do
      Timecop.travel '2013-6-1'

      invoicing_page.load
      invoicing_page.invoice_date = Time.zone.tomorrow.to_s
      invoicing_page.search_term('87').create

      expect(invoicing_page.invoice_date).to eq Time.zone.tomorrow.to_s

      Timecop.return
    end
  end

  describe 'errors when the property range' do
    it 'excludes all existing properties' do
      Timecop.travel '2013-6-1'

      invoicing_page.load
      invoicing_page.search_term('87').create

      expect(invoicing_page).to be_excluded

      Timecop.return
    end

    it 'does not include a chargeable property for the billing-period' do
      Timecop.travel '2013-6-1'

      create_account human_ref: 87,
                     cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 25)])

      invoicing_page.load
      invoicing_page.search_term('87').create

      expect(invoicing_page).to be_not_actionable

      Timecop.return
    end
  end

  it 'does not invoice properties that would be in credit after billing' do
    Timecop.travel '2013-6-1'

    cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
    charge = charge_new(payment_type: 'manual', cycle: cycle)
    account_create property: property_new(human_ref: 9),
                   charges: [charge],
                   credits: [credit_new(charge: charge,
                                        at_time: '2000-1-1',
                                        amount: 100)]
    invoicing_page.load
    invoicing_page.search_term('9').create
    invoicing_page.load invoicing: Invoicing.first

    expect(invoicing_page).to be_actionable
    expect(invoicing_page).to be_none_delivered

    Timecop.return
  end

  describe 'warns on' do
    describe 'retains mail' do
      it 'to properties that only have automatic charges.' do
        Timecop.travel '2013-6-1'

        cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
        account_create property: property_new(human_ref: 9),
                       charges: [charge_new(payment_type: 'automatic',
                                            cycle: cycle)]
        invoicing_page.load
        invoicing_page.search_term('9').create
        invoicing_page.load invoicing: Invoicing.first

        expect(invoicing_page).to be_actionable
        expect(invoicing_page).to_not be_none_retained

        Timecop.return
      end

      # The test for retaining mail is the absence of a string, a weak test.
      # This test is to bolster the weak test with one the tests for a string's
      # presence.
      #
      it 'will not retain when cash payment due' do
        Timecop.travel '2013-6-1'

        cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
        account_create property: property_new(human_ref: 9),
                       charges: [charge_new(payment_type: 'manual',
                                            cycle: cycle)]
        invoicing_page.load
        invoicing_page.search_term('9').create
        invoicing_page.load invoicing: Invoicing.first

        expect(invoicing_page).to be_actionable
        expect(invoicing_page).to be_none_retained

        Timecop.return
      end
    end

    describe 'ignoring mail' do
      it 'to properties that have no charges in billing-period.' do
        Timecop.travel '2013-6-1'

        create_account human_ref: 8,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 5, day: 1)])
        create_account human_ref: 9,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 25)])

        invoicing_page.load
        invoicing_page.search_term('8-9').create
        invoicing_page.load invoicing: Invoicing.first

        expect(invoicing_page).to be_actionable
        expect(invoicing_page).to_not be_none_ignored

        Timecop.return
      end

      it 'displays none if every property can be charged.' do
        Timecop.travel '2013-6-1'

        create_account human_ref: 9,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 25)])

        invoicing_page.load
        invoicing_page.search_term('9').create
        invoicing_page.load invoicing: Invoicing.first

        expect(invoicing_page).to be_actionable
        expect(invoicing_page).to be_none_ignored

        Timecop.return
      end
    end
  end

  def create_account(human_ref:, cycle:)
    account_create property: property_new(human_ref: human_ref),
                   charges: [charge_new(cycle: cycle)]
  end
end
