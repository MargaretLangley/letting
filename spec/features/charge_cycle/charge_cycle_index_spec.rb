require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in
    charge_cycle_create name: 'Jan/July', order: 6
    visit '/charge_cycles/'
  end

  context '#index' do

    it 'basic' do
      expect(current_path).to eq '/charge_cycles/'
      expect(page.title).to eq 'Letting - Charge Cycles'
      expect(page).to have_text 'Jan/July'
      expect(page).to have_text '6'
    end

    it 'has no search' do
      expect(page).to_not have_text 'Search here'
    end

    it 'has edit link' do
      first(:link, 'Edit').click
      expect(page.title).to eq 'Letting - Edit Charge Cycles'
    end

    it 'has delete link' do
      expect(page).to have_link 'Delete'
    end

  end
end
