require 'spec_helper'

describe 'Session' do

  it '#creates' do
    user_factory user_attributes id: 1
    navigates_to_create_page
    fill_in_login
    expect_to
  end

  it '#creates - fails' do
    navigates_to_create_page
    fill_in_login
    expect_failure
  end

  def navigates_to_create_page
    visit '/sessions/new/'
  end

  def fill_in_login
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log In'
  end

  def expect_to
    expect(current_path).to eq '/'
    expect(page).to have_text 'Logged in!'
  end

  def expect_failure
    expect(current_path).to eq '/sessions'
    expect(page).to have_text 'Email or password is invalid'
  end
end