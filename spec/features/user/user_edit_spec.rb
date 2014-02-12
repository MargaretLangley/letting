require 'spec_helper'

describe User do
  let(:user_edit_page) { UserEditPage.new }
  before(:each) { log_in admin_attributes }

  context '#edit' do
    it 'edit user' do
      go_to_edit_page
      user_edit_page.fill_form('another', 'another@example.com', 'password')
      user_edit_page.click_update_user
      expect(page).to have_text /successfully updated!/i
    end
  end

  context '#edit' do
    it 'no password confirmation' do
      go_to_edit_page
      user_edit_page.fill_form('another', 'another@example.com', 'password', 'pass')
      user_edit_page.click_update_user
      expect(page).to have_text /invalid/i
    end
  end

  def go_to_edit_page
    user_edit_page.visit_index_page
    expect(current_path).to eq '/users'
    user_edit_page.click_edit
    expect(page).to have_text 'Password confirmation'
    expect(page).to have_text 'Admin'
  end

end
