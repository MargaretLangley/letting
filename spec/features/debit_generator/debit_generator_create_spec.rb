require 'rails_helper'

describe 'debit_generator', :ledgers, type: :feature do
  let(:debit_gen_page) { DebitGeneratorCreatePage.new }
  before(:each) { log_in }

  describe '#create' do
    before { Timecop.travel Date.new(2013, 1, 31) }
    after  { Timecop.return }

    it 'charges a property that matches the search' do

      charge = charge_new charge_type: 'Rent',
                          charged_in: charged_in_create(id: 2)
      # Client required because controller starts invoicing
      #  immediately. Be nice to disconnect this requirement.
      client_create \
        property: property_create(human_ref: 87,
                                  account: account_new(charge: charge))

      sheet_create id: 1,
                   description: 'Page 1 Invoice',
                   invoice_name: 'Bell',
                   phone: '01710008',
                   vat: '89',
                   heading1: 'give you notice pursuant'

      debit_gen_page.enter.search_term('87').search
      expect(page).to have_text '87'
      expect(page).to have_text 'Rent'
      debit_gen_page.make_charges
      expect(debit_gen_page).to be_created
    end

    it 'errors on queries without a valid account' do
      charge = charge_new charged_in: charged_in_create(id: 2)
      property_create human_ref: 87, account: account_new(charge: charge)
      debit_gen_page.enter.search_term('102-109').search
      expect(debit_gen_page).to be_without_accounts
    end
  end
end
