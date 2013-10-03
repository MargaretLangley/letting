require 'spec_helper'

describe User do

  before(:each) { log_in admin_attributes }

  context '#edit' do
    it 'basic' do
      go_to_create_page
      within_fieldset 'user' do
        fill_in 'Email', with: 'newuser@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
      end
      click_on 'Create User'
      expect(page).to have_text /successfully created!/i
      expect(page).to have_text 'newuser@example.com'

    end
  end

  context '#edit' do
    it 'no password confirmation' do
      go_to_create_page
      within_fieldset 'user' do
        fill_in 'Email', with: 'newuser@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'pass'
      end
      click_on 'Create User'
      expect(page).to have_text /Form is invalid/i
    end
  end

  def go_to_create_page
      click_on 'Add New User'
      expect(page).to have_text 'Password confirmation'
      expect(page).to have_text 'Admin'
  end

end