require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in
    charge_cycle_create id: 3,
                        name: 'Jan/July',
                        order: 11,
                        due_ons: [DueOn.new(day: 6, month: 10)]
    visit '/charge_cycles/3'
  end

  it 'has basic details' do
    expect(page.title). to eq 'Letting - View Charge Cycle'
    expect(page). to have_text 'Jan/July'
    expect(page). to have_text '11'
    expect(page). to have_text '6'
    expect(page). to have_text '10'
  end

  it 'has edit link' do
    click_on('Edit')
    expect(page.title). to eq 'Letting - Edit Charge Cycles'
  end

end
