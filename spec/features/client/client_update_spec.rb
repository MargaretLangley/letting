require 'spec_helper'

describe Client do

  it '#updates' do
    client_factory id: 1, human_client_id: 3003
    navigate_to_edit_page
    validate_on_edit_page
    expect_form_to_be
    fill_in_form
    click_on 'Update Client'
    expect_clients

    visit '/clients/1'
    expect_client_updates
  end

  it '#update handles validation' do
    client_factory id: 1, human_client_id: 3003
    navigate_to_edit_page
    validate_on_edit_page
    clear_address_road
    click_on 'Update Client'
    expect(current_path).to eq '/clients/1'
    expect(page).to have_text 'The client could not be saved.'
  end

  def navigate_to_edit_page
    visit '/clients/'
    click_on 'Edit'
  end

  def validate_on_edit_page
    expect(current_path).to eq '/clients/1/edit'
  end

  def expect_form_to_be
    expect_client_has_original_attributes
    expect_address_has_original_attributes
    expect_entity_has_original_attributes
  end

    def expect_client_has_original_attributes
      expect(find_field('client_human_client_id').value).to have_text '3003'
    end

    def expect_address_has_original_attributes
      within_fieldset 'client_address' do
        expect(find_field('Flat no').value).to have_text '47'
        expect(find_field('House name').value).to have_text 'Hillbank House'
        expect(find_field('Road no').value).to have_text '294'
        expect(find_field('Road').value).to have_text 'Edgbaston Road'
        expect(find_field('District').value).to have_text 'Edgbaston'
        expect(find_field('Town').value).to have_text 'Birmingham'
        expect(find_field('County').value).to have_text 'West Midlands'
        expect(find_field('Postcode').value).to have_text 'B5 7QU'
      end
    end

    def expect_entity_has_original_attributes
      within_fieldset 'client_entity_0' do
        expect(find_field('Title').value).to have_text 'Mr'
        expect(find_field('Initials').value).to have_text 'W G'
        expect(find_field('Name').value).to have_text 'Grace'
      end
    end

  def fill_in_form
    fill_in 'client_human_client_id', with: '3004'
    fill_in_address
    fill_in_entity
  end

    def fill_in_address
       within_fieldset 'client_address' do
        fill_in 'Flat no', with: '58'
        fill_in 'House name', with: 'River Brook'
        fill_in 'Road no', with: '11c'
        fill_in 'Road', with: 'Surrey Road'
        fill_in 'District', with: 'Merton'
        fill_in 'Town', with: 'London'
        fill_in 'County', with: 'Greater'
        fill_in 'Postcode', with: 'SW1 4HA'
      end
    end

    def fill_in_entity
      within_fieldset 'client_entity_0' do
        fill_in 'Title', with: 'Dr'
        fill_in 'Initials', with: 'B M'
        fill_in 'Name', with: 'Zeperello'
      end
    end

  def expect_clients
    expect(current_path).to eq '/clients'
    expect(page).to have_text 'Client successfully updated!'
    expect_client_data_changed
  end

    def expect_client_data_changed
      expect(page).to_not have_text '3003'
      expect(page).to have_text '3004'
      expect(page).to_not have_text '294'
      expect(page).to have_text '11c'
    end

  def expect_client_updates
    expect_new_address
    expect_new_entity
  end

    def expect_new_address
      expect(page).to have_text '58'
      expect(page).to have_text 'River Brook'
      expect(page).to have_text 'Merton'
      expect(page).to have_text 'Surrey Road'
      expect(page).to have_text 'London'
      expect(page).to have_text 'Greater'
      expect(page).to have_text 'SW1 4HA'
    end

    def expect_new_entity
      expect(page).to have_text 'Dr'
      expect(page).to have_text 'B M'
      expect(page).to have_text 'Zeperello'
    end

  def clear_address_road
    within_fieldset 'client_address' do
      fill_in 'Road', with: ''
    end
  end
end
