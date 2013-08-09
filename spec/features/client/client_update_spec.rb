require 'spec_helper'
require_relative 'client_shared'
require_relative '../shared/entity'

describe Client do

  it '#updates' do
    client_factory id: 1, human_client_id: 3003
    navigate_to_edit_page
    validate_page
    fill_in_form
    click_on 'Update Client'
    expect_clients_page
    navigate_to_client_page
    expect_client_page
  end

  it '#update handles validation' do
    client_factory id: 1, human_client_id: 3003
    navigate_to_edit_page
    invalidate_page
    click_on 'Update Client'
    expect(current_path).to eq '/clients/1'
    expect(page).to have_text 'The client could not be saved.'
  end

  def navigate_to_edit_page
    visit '/clients/'
    click_on 'Edit'
  end

  def validate_page
    expect(current_path).to eq '/clients/1/edit'
    expect_client_has_original_attributes
    expect_address_has_original_attributes
    expect_entity_has_original_attributes
  end

    def expect_client_has_original_attributes
      expect(find_field('client_human_client_id').value).to have_text '3003'
    end

    def expect_address_has_original_attributes
      within_fieldset 'client_address' do
        expect_address_edgbaston_by_field
      end
    end

    def expect_entity_has_original_attributes
      expect(page.all('h3', text: 'Person').count).to eq 2
      within_fieldset 'client_entity_0' do
        expect_entity_wg_grace_by_field
      end
    end


  def expect_clients_page
    expect(current_path).to eq '/clients'
    expect(page).to have_text 'Client successfully updated!'
    expect_client_data_changed
  end

    def expect_client_data_changed
      expect(page).to_not have_text '3003'
      expect(page).to have_text '278'
      expect(page).to_not have_text '294'
      expect(page).to have_text '63c'
    end
end
