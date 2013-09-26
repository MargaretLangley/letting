require 'spec_helper'

describe 'debt_generator' do
  before(:each) { log_in }

  it 'notifies when nothing found' do
    visit '/debt_generators/'
    fill_in 'search', with: 'Garbage'
    click_on 'Search'
    expect(current_path).to eq '/debt_generators'
    expect(find_field'search').to have_text 'Garbage'
  end

  it 'creates debts' do
    property_factory_with_charge
    visit '/debt_generators'
  end
end