require 'rails_helper'

describe 'User#update', type: :feature do
  let(:user_page) { UserPage.new }
  before(:each) { log_in admin_attributes }

  it 'completes basic' do
    user = user_create
    user_page.load id: user.id
    expect(user_page.title).to eq 'Letting - Edit User'

    user_page.fill_form 'nother', 'nother@example.com', 'pass', 'pass'
    user_page.button 'Update'
    expect(user_page).to be_successful
  end

  it 'displays form errors' do
    user = user_create
    user_page.load id: user.id
    user_page.fill_form 'nother', 'nother&example.com', 'pass', 'pass'
    user_page.button 'Update'
    expect(user_page).to be_errored
  end
end
