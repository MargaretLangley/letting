require 'spec_helper'

describe 'debit_generator' do
  let(:debit_gen_page) { DebitGeneratorCreatePage.new }
  before(:each) { log_in }

  describe '#create' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after  { Timecop.return }

    it 'errors without a valid account' do
      property_with_charge_create! human_ref: 99
      debit_gen_page.visit_page.search_term('102-109').search
      expect(debit_gen_page).to be_without_accounts
    end

    it 'charges a property that matches the search' do
      property = property_with_charge_create! \
                   human_ref: 2002,
                   address_attributes: { road: 'Talbot Road' }
      # Client required because controller starts invoicing immediately
      # Be nice to disconnect this requirement.
      property.client = client_create!
      property.save!
      debit_gen_page.visit_page.search_term('Talbot Road').search
      expect(page).to have_text '2002'
      expect(page).to have_text 'Ground Rent'
      debit_gen_page.make_charges
      save_and_open_page
      expect(debit_gen_page).to be_created
    end
  end

end
