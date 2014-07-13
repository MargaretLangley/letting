require 'spec_helper'

describe User, type: :feature do
  let(:user_create_page) { UserCreatePage.new }
  before(:each) { log_in admin_attributes }

  it 'creates a user' do
    user_create_page.visit_page
    user_create_page.fill_form('newuser', 'newuser@example.com', 'password', 'password')
    user_create_page.click
    expect(page).to have_text /successfully created!/i
    expect(page).to have_text 'newuser@example.com'
  end

  it 'does not create a user without password confirmation' do
    user_create_page.visit_page
    user_create_page.fill_form('newuser' 'newuser@example.com', 'password', 'pass')
    user_create_page.click
    expect(page).to have_text /invalid/i
    expect(page).to_not have_text 'newuser@example.com'
  end
end
