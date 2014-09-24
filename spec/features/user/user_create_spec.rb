require 'rails_helper'

describe User, type: :feature do
  let(:user_page) { UserCreatePage.new }
  before(:each) { log_in admin_attributes }

  it 'creates a user' do
    user_page.enter
    user_page.fill_form 'newuser', 'newuser@example.com', 'password', 'password'
    user_page.click
    expect(user_page).to be_successful
    expect(page).to have_text 'newuser@example.com'
  end

  it 'displays form errors' do
    user_page.enter
    user_page.click
    expect(user_page).to be_errored
  end
end
