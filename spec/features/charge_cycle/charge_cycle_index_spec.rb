require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in admin_attributes
    charge_cycle_create id: 1, name: 'Jan/July', order: 6, period_type: 'term'
  end
  context '#index' do

    it 'basic' do
      visit '/charge_cycles/'
      expect(current_path).to eq '/charge_cycles/'
      expect(page.title).to eq 'Letting - Charge Cycles'
      expect(page).to have_text 'Jan/July'
      expect(page).to have_text '6'
    end

    it 'has edit link' do
      visit '/charge_cycles/'
      first(:link, 'Edit').click
      expect(page.title).to eq 'Letting - Edit Charge Cycles'
    end

    it 'has delete link' do
      visit '/charge_cycles/'
      expect(page).to have_link 'Delete'
    end

    it 'has ordered list' do
      charge_cycle_create id: 2, name: 'Feb/July', order: 2
      visit '/charge_cycles/'
      first(:link, 'Edit').click
      expect(find_field('Name').value).to have_text 'Feb/July'
      expect(find_field('Order').value).to have_text '2'
    end
  end
end
