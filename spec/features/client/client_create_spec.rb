require 'spec_helper'
require_relative 'client_shared'

describe Client do

  it '#creates', js: true do
    navigate_to_create_page
    validate_page
    fill_in_form
    click_on 'Create Client'
    expect_clients_page
    navigate_to_client_page '278'
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

  it '#adds and removes new persons', js: true do
    navigate_to_create_page
    fill_in_form
    click_on 'Add Person'
    within_fieldset 'client_entity_1' do
      fill_in 'Name', with: 'test'
      click_on 'X'
    end
    click_on 'Add Person'
    expect(page.all('h3', text: 'Person or company').count).to eq 2
    within_fieldset 'client_entity_1' do
      # expect(find_field('Name').value).to be_blank
    end
  end

  it 'swiches between company and person', js:true do
    navigate_to_create_page
    expect(page).to have_text 'Initials'
    click_on 'or company'
    expect(page).to_not have_text 'Initials'
    click_on 'or person'
    expect(page).to have_text 'Initials'
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
