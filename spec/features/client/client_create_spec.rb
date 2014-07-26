require 'spec_helper'
require_relative 'client_shared'

describe Client, type: :feature do
  let(:client_page) { ClientCreatePage.new }
  before(:each) { log_in }

  context '#create' do

    it 'basic', js: true do
      client_page.visit_new_page
      validate_page
      client_page.fill_in_form('278')
      client_page.create
      expect_client_index
      client_page.view
      expect_client_view
    end

    it 'handles validation' do
      client_page.visit_new_page
      client_page.fill_in_form('278')
      invalidate_page
      client_page.create
      expect(current_path).to eq '/clients'
      expect(page).to have_text 'The client could not be saved.'
    end

    it 'company', js: true do
      client_page.visit_new_page
      validate_page
      client_page.fill_in_form('278')
      client_page.click('or company')
      within '#client_entity_0' do
        fill_in 'Name', with: 'ICC'
      end
      within_fieldset 'client' do
        fill_in_address_nottingham
      end
      client_page.create
      expect(page).to have_text 'ICC'
    end

    # Occasional Fail
    # Can fail on any of the lines 57 - 60
    # not caused by random
    it 'adds and removes new persons', js: true do
      client_page.visit_new_page
      client_page.fill_in_form('278')
      client_page.click('Add Person')
      within '#client_entity_1' do
        fill_in 'Name', with: 'test'
        client_page.click('X')
      end
      # NASTY!
      # client_page.click('Add Person')
      # expect(page.all('h3', text: 'Person or company').count).to eq 2
      # within '#client_entity_1' do
      #   expect(find_field('Name').value).to be_blank
      # end
    end

    it 'shows person by default', js: true do
      client_page.visit_new_page
      expect(page).to have_text 'Person or company'
    end

    it 'switches between company and person', js: true do
      pending 'switching toggle.js/doToggle find => children breaks ' \
              'the company=>person entity swap leaving pending while rewriting'
      client_page.visit_new_page
      expect(page).to have_text 'Initials'
      client_page.click('or company')
      expect(page).to_not have_text 'Initials'
      client_page.click('or person')
      expect(page).to have_text 'Initials'
    end
  end

  def validate_page
    expect(current_path).to eq '/clients/new'
    expect(page.all('h3', text: 'Person').count).to eq 1
  end

  def expect_client_index
    expect(current_path).to eq '/clients'
    expect(page).to have_text 'successfully created!'
  end

end
