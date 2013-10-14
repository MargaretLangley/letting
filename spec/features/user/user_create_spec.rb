require 'spec_helper'

describe User do
  let(:user_create_page) { UserCreatePage.new }
  before(:each) { log_in admin_attributes }

  context '#create' do
    it 'create basic password' do
      user_create_page.visit_new_page
      user_create_page.login('newuser@example.com', 'password')
      user_create_page.click_create_user
      expect(page).to have_text /successfully created!/i
      expect(page).to have_text 'newuser@example.com'
    end
  end

  context '#create' do
    it 'no password confirmation' do
      user_create_page.visit_new_page
      user_create_page.login('newuser@example.com', 'password', 'pass')
      user_create_page.click_create_user
      expect(page).to have_text /Form is invalid/i
    end
  end

end
