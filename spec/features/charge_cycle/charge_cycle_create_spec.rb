require 'rails_helper'

describe ChargeCycle, type: :feature do
  before(:each) { log_in admin_attributes }

  it 'creates a charge cycle' do
    visit '/charge_cycles/new'
    expect(page.title).to eq 'Letting - New Charge Cycles'
    fill_in 'Name', with: 'April/Nov'
    fill_in 'Order', with: '44'
    due_on(day: 10, month: 2)
    click_on 'Create Charge cycle'
    expect(page).to have_text /successfully created!/i
  end

  def due_on(order: 0, day:, month:, year: nil)
    id_stem = "charge_cycle_due_ons_attributes_#{order}"
    fill_in "#{id_stem}_day", with: day
    fill_in "#{id_stem}_month", with: month
    fill_in "#{id_stem}_year", with: year
  end

  it 'displays form errors' do
    visit '/charge_cycles/new'
    click_on 'Create Charge cycle'
    expect(page).to have_css '[data-role="errors"]'
  end
end
