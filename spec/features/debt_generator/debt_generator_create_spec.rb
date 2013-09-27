require 'spec_helper'

describe 'debt_generator' do
  before(:each) { log_in }

  it 'notifies when nothing found' do
    visit '/debt_generators/new'
    fill_in 'search', with: 'Garbage'
    click_on 'Search'
    expect(current_path).to eq '/debt_generators/new'
    expect(page).to have_text /No properties found. Searched for: 'Garbage'/i
  end

  it 'creates debts' do
    property_with_charge_new
    visit '/debt_generators/new'
    fill_in 'search', with: ''
  end
end