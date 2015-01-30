require 'rails_helper'

describe 'User#update', type: :feature do
  let(:user_page) { UserPage.new }
  before(:each) { log_in admin_attributes }

  it 'completes basic' do
    user_create id: 3
    user_page.load id: 3
    expect(page.title).to eq 'Letting - Edit User'

    user_page.fill_form 'nother', 'nother@example.com', 'pass', 'pass'
    user_page.button action: 'Update'
    expect(user_page).to be_successful
  end

  it 'displays form errors' do
    user_create id: 4
    user_page.load id: 4
    user_page.fill_form 'nother', 'nother&example.com', 'pass', 'pass'
    user_page.button action: 'Update'
    expect(user_page).to be_errored
  end
end
