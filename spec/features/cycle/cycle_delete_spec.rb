require 'rails_helper'

describe Cycle, :ledgers, type: :feature do

  before(:each) do
    log_in admin_attributes
    cycle_create id: 3,
                 name: 'Jan/July',
                 order: 6,
                 cycle_type: 'term'
    visit '/cycles/'
  end

  it '#destroys' do
    expect(page.title).to eq 'Letting - Charge Cycles'
    expect(page).to have_text 'Jan/July'
    expect { click_on 'Delete' }.to change(Cycle, :count).by(-1)
    expect(page).to have_text 'Jan/July'
    expect(page).to have_text 'successfully deleted'
    expect(page.title).to eq 'Letting - Charge Cycles'
  end
end
