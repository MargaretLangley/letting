require 'rails_helper'

describe 'User update', type: :feature do
  let(:user_edit_page) { UserEditPage.new }
  before(:each) { log_in admin_attributes }

  it 'can complete update' do
    go_to_edit_page
    expect(page.title).to eq 'Letting - Edit User'
    user_edit_page.fill_form('nother', 'nother@example.com', 'pass', 'pass')
    user_edit_page.click_update_user
    expect(user_edit_page).to be_successful
  end

  it 'displays form errors' do
    go_to_edit_page
    user_edit_page.fill_form('nother', 'nother&example.com', 'pass', 'pass')
    user_edit_page.click_update_user
    expect(user_edit_page).to be_errored
  end

  def go_to_edit_page
    user_edit_page.visit_index_page
    expect(current_path).to eq '/users'
    user_edit_page.click_edit
  end
end
