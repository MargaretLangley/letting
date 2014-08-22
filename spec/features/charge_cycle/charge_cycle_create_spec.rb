require 'rails_helper'

describe ChargeCycle, type: :feature do
  let(:charge_cycle_create_page) { ChargeCycle.new }
  before(:each) { log_in admin_attributes }

  it 'creates a charge cycle' do
    visit '/charge_cycles/new'
    # charge_cycle_create_page.fill_form('April/Nov', '34')
    # charge_cycle_create_page.click
    # expect(page).to have_text /successfully created!/i
    # expect(page).to have_text 'New'
  end

 end
