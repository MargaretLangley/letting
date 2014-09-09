require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in
    charge_cycle_create id: 3,
                        name: 'Jan/July',
                        order: 11,
                        period_type: 'term',
                        due_ons: [DueOn.new(day: 6, month: 10)]
  end

  it 'has basic details' do
    visit '/charge_cycles/3'
    expect(page.title). to eq 'Letting - View Charge Cycle'
    expect(page).to have_text 'Jan/July'
    expect(page).to have_text '11'
    expect(page).to have_text '6'
    expect(page).to have_text '10'
  end

  it 'has edit link' do
    visit '/charge_cycles/3'
    click_on('Edit')
    expect(page.title).to eq 'Letting - Edit Charge Cycles'
  end

  it 'has monthly details' do
    charge_cycle_create id: 2,
                        name: 'Every Month',
                        order: 6,
                        period_type: 'monthly',
                        due_ons: [DueOn.new(day: 4, month: 5)]
    visit '/charge_cycles/2'
    expect(page).to have_text 'Every Month'
    expect(page).to have_text '20'
    expect(page).to have_text '4'
    expect(page).to_not have_text '5'
  end
end
