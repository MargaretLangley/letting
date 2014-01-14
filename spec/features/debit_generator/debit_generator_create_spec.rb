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

    it 'debits' do
      pending 'MARGARET LANGLEY remove this pending and get this to pass'
      property_with_charge_create!
      debit_gen_page.visit_page
      debit_gen_page.search_term('Hillbank House').search
      expect(page).to have_text '2002'
      expect(page).to have_text 'Ground rent'
      debit_gen_page.make_charges
      # SEE THE ERROR HERE
      save_and_open_page
      expect(debit_gen_page).to be_created
    end
  end
end
