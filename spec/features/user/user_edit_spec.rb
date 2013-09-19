require 'spec_helper'

describe User do

  before(:each) { log_in admin_attributes}

  context '#edit' do
    it 'basic' do
      go_to_edit_page
      within_fieldset 'user' do
        fill_in "Email", with: 'another@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
      end
      click_on 'Update User'
      expect(page).to have_text /successfully updated!/i
    end
  end

  context '#edit' do
    it 'no password confirmation' do
      go_to_edit_page
      within_fieldset 'user' do
        fill_in "Email", with: 'another@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'pass'
      end
      click_on 'Update User'
      expect(page).to have_text /Form is invalid/i
    end
  end

  def go_to_edit_page
      visit '/users/'
      expect(current_path).to eq '/users/'
      click_on 'Edit'
      expect(page).to have_text 'Password confirmation'
      expect(page).to have_text 'Admin'
    end
end