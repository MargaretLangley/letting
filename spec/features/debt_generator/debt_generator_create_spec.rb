require 'spec_helper'

describe 'debt_generator' do
  let(:debt_gen_page) { DebtGeneratorCreatePage.new }
  before(:each) { log_in }

  it 'Errors' do
    debt_gen_page.visit_page.search_term('Garbage').search
    expect(current_path).to eq '/debt_generators'
    expect(debt_gen_page).to be_have_no_properties
  end

  context 'creates' do
    before { Timecop.travel(Date.new(2013, 1, 31)) }
    after  { Timecop.return }

    it 'debts' do
      property_with_charge_create!
      debt_gen_page.visit_page
      debt_gen_page.search_term('Hillbank House').search
      expect(page).to have_text '2002'
      expect(page).to have_text 'Ground rent'
      debt_gen_page.make_charges
      expect(debt_gen_page).to be_created
    end
  end
end
