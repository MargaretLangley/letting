require 'spec_helper'
require_relative 'client_shared'

describe Client do
  let(:client_create_page) { ClientCreatePage.new }
  before(:each) { log_in }

  context '#create' do

    it 'basic', js: true do
      client_create_page.visit_new_page
      validate_page
      client_create_page.fill_in_form('278')
      client_create_page.click_create_client
      expect_client_index
      client_create_page.click('View')
      expect_client_view
    end

    it 'handles validation' do
      client_create_page.visit_new_page
      client_create_page.fill_in_form('278')
      invalidate_page
      client_create_page.click_create_client
      expect(current_path).to eq '/clients'
      expect(page).to have_text 'The client could not be saved.'
    end

    it 'company', js: true do
      client_create_page.visit_new_page
      validate_page
      client_create_page.fill_in_form('278')
      client_create_page.click('or company')
      within_fieldset 'client_entity_0' do
        fill_in 'Name', with: 'ICC'
      end
      within_fieldset 'client_address' do
        fill_in_address_nottingham
      end
      client_create_page.click_create_client
      expect(page).to have_text 'ICC'
    end

    it 'adds and removes new persons', js: true do
      client_create_page.visit_new_page
      client_create_page.fill_in_form('278')
      client_create_page.click('Add Person')
      within_fieldset 'client_entity_1' do
        fill_in 'Name', with: 'test'
        client_create_page.click('X')
      end
      client_create_page.click('Add Person')
      expect(page.all('h3', text: 'Person or company').count).to eq 2
      within_fieldset 'client_entity_1' do
        expect(find_field('Name').value).to be_blank
      end
    end

    it 'shows person by default', js: true do
      client_create_page.visit_new_page
      expect(page).to have_text 'Person or company'
    end

    it 'swiches between company and person', js: true do
      client_create_page.visit_new_page
      expect(page).to have_text 'Initials'
      client_create_page.click('or company')
      expect(page).to_not have_text 'Initials'
      client_create_page.click('or person')
      expect(page).to have_text 'Initials'
    end
  end

  def validate_page
    expect(current_path).to eq '/clients/new'
    expect(page.all('h3', text: 'Person').count).to eq 1
  end

  def expect_client_index
    expect(current_path).to eq '/clients'
    expect(page).to have_text /client successfully created!/i
  end

end
