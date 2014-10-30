require 'rails_helper'

describe Cycle, :ledgers, type: :feature do

  before(:each) do
    log_in admin_attributes
    cycle_create id: 1, name: 'Jan/July', order: 6, cycle_type: 'term'
  end
  context '#index' do

    it 'basic' do
      visit '/cycles/'
      expect(current_path).to eq '/cycles/'
      expect(page.title).to eq 'Letting - Cycles'
      expect(page).to have_text 'Jan/July'
      expect(page).to have_text '6'
    end

    it 'has edit link' do
      visit '/cycles/'
      first(:link, 'Edit').click
      expect(page.title).to eq 'Letting - Edit Cycle'
    end

    it 'has delete link' do
      visit '/cycles/'
      expect(page).to have_link 'Delete'
    end

    it 'has ordered list' do
      cycle_create id: 2, name: 'Feb/July', order: 2
      visit '/cycles/'
      first(:link, 'Edit').click
      expect(find_field('Name').value).to have_text 'Feb/July'
      expect(find_field('Order').value).to have_text '2'
    end
  end
end
