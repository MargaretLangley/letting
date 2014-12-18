require 'rails_helper'

describe 'Invoicing#show', type: :feature do
  it 'basic' do
    log_in
    invoicing_create id: 1,
                     property_range: '1-100',
                     period_first: '2014/06/30',
                     period_last: '2014/08/30'

    visit '/invoicings/1'
    expect(page.title).to eq 'Letting - View Invoicing'
    expect(page).to have_text '1-100'
  end

  describe 'retained message' do
    # Mail: false then: Retaining. Deliver Message, Invoice under Retain.
    #
    it 'inform, if no invoice retained' do
      log_in
      invoice = invoice_new mail: false # Retaining mail
      invoicing_create id: 1, runs: [run_new(invoices: [invoice])]

      visit '/invoicings/1'
      expect(page.has_no_content? /No invoices will be retained./i).to be true
    end

    # Mail: false then: Deliver. Retain Message, Invoice under Deliver.
    #
    it 'do nothing, if any invoice retained' do
      log_in
      invoice = invoice_new mail: true  # nothing retained
      invoicing_create id: 1, runs: [run_new(invoices: [invoice])]

      visit '/invoicings/1'
      expect(page.has_content? /No invoices will be retained./i).to be true
    end
  end

  describe 'deliver message' do
    # Mail: false then: Not delivering. Deliver Message, Invoice under Retain.
    #
    it 'inform, if no invoice delivered' do
      log_in
      invoice = invoice_new mail: false # No Mail delivered
      invoicing_create id: 1, runs: [run_new(invoices: [invoice])]

      visit '/invoicings/1'
      expect(page.has_content? /No invoices will be delivered./i).to be true
    end

    # Mail: true then: Delivering. Invoice under Deliver, Retain message.
    #
    it 'do nothing, if any invoice delivered' do
      log_in
      invoice = invoice_new mail: true # Deliver mail
      invoicing_create id: 1, runs: [run_new(invoices: [invoice])]

      visit '/invoicings/1'
      expect(page.has_no_content? /No invoices will be delivered./i).to be true
    end
  end
end
