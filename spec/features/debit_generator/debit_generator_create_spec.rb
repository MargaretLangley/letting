require 'spec_helper'

describe 'debit_generator', type: :feature do
  let(:debit_gen_page) { DebitGeneratorCreatePage.new }
  before(:each) { log_in }

  describe '#create' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after  { Timecop.return }

    it 'charges a property that matches the search' do
      charged_in = charged_in_create(name: 'Advance')
      charge_structure_create charged_in_id: charged_in.id
      property = property_with_charge_create human_ref: 2002
      Property.import force: true, refresh: true
      # Client required because controller starts invoicing immediately
      # Be nice to disconnect this requirement.
      property.client = client_create
      property.save!
      debit_gen_page.visit_page.search_term('2002').search
      expect(page).to have_text '2002'
      expect(page).to have_text 'Ground Rent'
      debit_gen_page.make_charges
      expect(debit_gen_page).to be_created
      Property.__elasticsearch__.delete_index!
    end

    it 'errors without a valid account' do
      charge_structure_create
      property_with_charge_create human_ref: 99
      debit_gen_page.visit_page.search_term('102-109').search
      expect(debit_gen_page).to be_without_accounts
    end
  end

end
