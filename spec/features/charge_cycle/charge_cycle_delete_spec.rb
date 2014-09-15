require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in admin_attributes
    charge_cycle_create id: 3,
                        name: 'Jan/July',
                        order: 6,
                        period_type: 'term'
    visit '/charge_cycles/'
  end

  it '#destroys' do
    expect(page.title). to eq 'Letting - Charge Cycles'
    expect(page). to have_text 'Jan/July'
    expect { click_on 'Delete' }.to change(ChargeCycle, :count).by(-1)
    expect(page). to have_text 'Jan/July'
    expect(page). to have_text 'successfully deleted'
    expect(page.title). to eq 'Letting - Charge Cycles'
  end
end
