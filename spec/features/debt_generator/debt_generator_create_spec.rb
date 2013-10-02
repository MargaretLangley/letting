require 'spec_helper'

describe 'debt_generator' do
  before(:each) { log_in }

  it 'notifies when nothing found' do
    visit '/debt_generators/new'
    fill_in 'search', with: 'Garbage'
    click_on 'Search'
    expect(current_path).to eq '/debt_generators/new'
    expect(page).to have_text /No properties matching 'Garbage'/i
  end

  context 'creates' do
    before { Timecop.travel(Time.zone.parse('31/1/2013 12:00')) }
    after { Timecop.return }

    it 'debts' do
      property_with_charge_create!
      visit '/debt_generators/new'
      fill_in 'search', with: 'Hillbank House'
      click_on 'Search'
      expect(page).to have_text '2002'
      expect(page).to have_text 'Ground rent'
      click_on 'Make Charges Due'
      expect(page).to have_text /Debts successfully created!/i
    end
  end
end