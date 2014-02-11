require 'spec_helper'

describe 'debit_generator' do
  let(:debit_gen_page) { DebitGeneratorCreatePage.new }
  before(:each) { log_in }

  it 'Errors' do
    debit_gen_page.visit_page.search_term('Garbage').search
    expect(current_path).to eq '/debit_generators'
    expect(debit_gen_page).to be_have_no_properties
  end

  context 'creates' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after  { Timecop.return }


    it 'no invoices found' do
      property_with_charge_create!
      debit_gen_page.visit_page
      debit_gen_page.search_term('102-109').search
      expect(page).to have_text 'The invoicing could not be saved'
    end

    it 'reaches make charges' do
      property_with_charge_create!
      debit_gen_page.visit_page
      debit_gen_page.search_term('Hillbank House').search
      expect(page).to have_text '2002'
      expect(page).to have_text 'Ground Rent'
      debit_gen_page.make_charges
    end

    it 'debits' do
      property = property_with_charge_create!
      property.client = client_create! human_ref: 8989
      property.save!
      debit_gen_page.visit_page
      debit_gen_page.search_term('Hillbank House').search
      expect(page).to have_text '2002'
      expect(page).to have_text 'Ground Rent'
      debit_gen_page.make_charges
      expect(debit_gen_page).to be_created
    end


  end

end
