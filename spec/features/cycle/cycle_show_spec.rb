require 'rails_helper'

describe Cycle, :ledgers, type: :feature do
  before(:each) do
    log_in admin_attributes
    cycle_create id: 3,
                 name: 'Jan/July',
                 order: 11,
                 cycle_type: 'term',
                 due_ons: [DueOn.new(month: 1, day: 6),
                           DueOn.new(month: 7, day: 6)]
  end

  it 'has basic details' do
    visit '/cycles/3'

    expect(page.title).to eq 'Letting - View Cycle'
    expect(page).to have_text 'Jan/July'
  end

  it 'has edit link' do
    visit '/cycles/3'

    click_on('Edit')
    expect(page.title).to eq 'Letting - Edit Cycle'
  end

  it 'has monthly details' do
    cycle_create id: 2,
                 name: 'Every Month',
                 order: 6,
                 cycle_type: 'monthly',
                 due_ons: [DueOn.new(month: 5, day: 4)]
    visit '/cycles/2'

    expect(page).to have_text 'Every Month'
  end
end
