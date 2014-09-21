require 'rails_helper'

describe ChargeCycle, :ledgers, type: :feature do

  before(:each) { log_in admin_attributes }

  it 'creates a charge cycle' do
    visit '/charge_cycles/new?period=monthly'
    expect(page.title).to eq 'Letting - New Charge Cycles'
    fill_in 'Name', with: 'Monthly'
    fill_in 'Order', with: '44'
    due_on day: 10
    click_on 'Create Charge Cycle'
    expect(page).to have_text /successfully created!/i
  end

  def due_on(order: 0, day:)
    id_stem = "charge_cycle_due_ons_attributes_#{order}"
    fill_in "#{id_stem}_day", with: day
  end

  it 'displays form errors' do
    visit '/charge_cycles/new?period=monthly'
    click_on 'Create Charge Cycle'
    expect(page).to have_css '[data-role="errors"]'
  end
end
