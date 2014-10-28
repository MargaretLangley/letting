require 'rails_helper'

describe User, type: :feature do
  let(:user_edit_page) { UserEditPage.new }
  before(:each) { log_in admin_attributes }

  context '#edit' do
    it 'edit user successfully' do
      go_to_edit_page
      user_edit_page.fill_form('nother', 'nother@example.com', 'pass', 'pass')
      user_edit_page.click_update_user
      expect(page).to have_text /successfully updated!/i
    end

    it 'errors with incorrect email' do
      go_to_edit_page
      user_edit_page.fill_form('nother', 'nother&example.com', 'pass', 'pass')
      user_edit_page.click_update_user
      expect(page).to have_css '[data-role="errors"]'
    end

    it 'errors with blank password confirmation' do
      go_to_edit_page
      user_edit_page.fill_form('nother', 'nother@example.com', 'password', '')
      user_edit_page.click_update_user
      expect(page).to have_css '[data-role="errors"]'
    end

    it 'has no password confirmation' do
      go_to_edit_page
      user_edit_page
      .fill_form('another', 'another@example.com', 'password', 'pass')
      user_edit_page.click_update_user
      expect(page).to have_css '[data-role="errors"]'
    end

    it 'errors on update' do
      go_to_edit_page
      fill_in 'Nickname', with: ''
      user_edit_page.click_update_user
      expect(page).to have_css '[data-role="errors"]'
    end

    def go_to_edit_page
      user_edit_page.visit_index_page
      expect(current_path).to eq '/users'
      user_edit_page.click_edit
      expect(page.title). to eq 'Letting - Edit User'
    end
  end
end
