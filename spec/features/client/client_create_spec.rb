require 'spec_helper'
require_relative 'client_shared'

describe Client do

  it '#creates', js: true do
    navigate_to_create_page
    validate_page
    fill_in_form
    click_on 'Create Client'
    expect_clients_page
    navigate_to_client_page
    expect_client_page
  end

  it '#create handles validation' do
    navigate_to_create_page
    fill_in_form
    invalidate_page
    click_on 'Create Client'
    expect(current_path).to eq '/clients'
    expect(page).to have_text 'The client could not be saved.'
  end

  def navigate_to_create_page
    visit '/clients/'
    click_on 'Add New Client'
  end

  def validate_page
    expect(current_path).to eq '/clients/new'
    expect(page.all('h3', text: 'Person').count).to eq 1
  end

  def expect_clients_page
    expect(current_path).to eq '/clients'
    expect(page).to have_text 'CLIENT SUCCESSFULLY CREATED!'
  end

end
