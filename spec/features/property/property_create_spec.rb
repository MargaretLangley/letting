require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property, type: :feature do

  before(:each) { log_in }

  it '#create', js: true  do
    client_create!
    navigate_to_create_page
    validate_page
    expect(page).to have_css('.spec-entity-count', count: 1)
    fill_in_form
    click_on 'Create/Update Account'
    expect(page).to_not have_text 'The property could not be saved.'
    have_we_saved?
    expect_properties_page
    navigate_to_property_page
    expect_property_page
  end

  it '#creates a account without agent', js: true do
    client_create!
    navigate_to_create_page
    fill_in_property
    fill_in_property_address
    fill_in_property_entities
    click_on 'Create/Update Account'
    expect(current_path).to eq '/properties'
    navigate_to_property_page
    expect_property
    expect_property_address
    expect_property_entities
  end

  it '#create has validation', js: true do
    client_create!
    navigate_to_create_page
    invalidate_page
    click_on 'Create/Update Account'
    expect(current_path).to eq '/properties'
    expect(page).to have_text 'The property could not be saved.'
  end

  it 'adds charges', js: true do
    navigate_to_create_page
    expect(page).to have_css('.spec-charge-count', count: 1)
    click_on 'Add Charge'
    click_on 'Add Charge'
    click_on 'Add Charge'
    expect(page).to have_css('.spec-charge-count', count: 4)
  end

  def navigate_to_create_page
    visit '/properties'
    click_on 'New Account'
  end

  def validate_page
    expect(current_path).to eq '/properties/new'
  end

  def fill_in_form
    fill_in_property
    fill_in_property_address
    fill_in_property_entities
    fill_in_agent_address
    fill_in_agent_entities
    fill_in_charge
  end

  def fill_in_property
    fill_in 'Property ID', with: '278'
    fill_autocomplete('property_client_ref', with: '8008')
  end

  def fill_in_property_address
    within_fieldset 'property' do
      fill_in_address_nottingham
    end
  end

  def fill_in_property_entities
    within '#property_entity_0' do
      fill_in_entity_wg_grace2
    end
  end

  # Eventually method will be in shared/entity
  def fill_in_entity_wg_grace2
    id_stem = 'property_entities_attributes_0'
    fill_in "#{id_stem}_title", with: 'Mr'
    fill_in "#{id_stem}_initials", with: 'W G'
    fill_in "#{id_stem}_name", with: 'Grace'
  end

  def fill_in_agent_address
    check 'Agent'
    within '#agent' do
      fill_in 'Flat no', with: '555'
      fill_in 'House name', with: 'The County Ground'
      fill_in 'Road no', with: '68f'
      fill_in 'Road', with: 'Grandstand Road'
      fill_in 'Town', with: 'Derby'
      fill_in 'County', with: 'Derbyshire'
      fill_in 'Postcode', with: 'DE21 6AF'
    end
  end

  def fill_in_agent_entities
    id_stem = 'property_agent_attributes_entities_attributes_0'
    within '#agent_entity_0' do
      fill_in "#{id_stem}_name", with: 'K J Barnett'
    end
  end

  def fill_in_charge
    within '#property_charge_0' do
      id_stem = 'property_account_attributes_charges_attributes_0'
      fill_in "#{id_stem}_charge_type", with: 'Ground Rent'
      fill_in "#{id_stem}_due_in", with: 'Advance'
      fill_in "#{id_stem}_amount", with: '50.50'
    end
    fill_in_due_on
  end

  def fill_in_due_on
    within '#property_charge_0_due_on_0' do
      fill_in 'property_account_attributes_charges_' \
              'attributes_0_due_ons_attributes_0_day',
              with: 1
      fill_in 'property_account_attributes_charges_' \
              'attributes_0_due_ons_attributes_0_month',
              with: 1
    end
  end

  def we_saved?
    expect(current_path).to eq '/properties' # Not Saved
  end

  def invalidate_page
    fill_in_property
    fill_in_property_address
  end

  def expect_properties_page
    expect(current_path).to eq '/properties'
  end

  def navigate_to_property_page
    find('.view-testing-link', visible: false).click
  end

  def expect_property_page
    expect_property
    expect_property_address
    expect_property_entities
    expect_agent_address
    expect_agent_entities
    expect_charges
  end

  def expect_property
    expect(page).to have_text '278'
  end

  def expect_property_address
    click_on 'Full Property'
    expect_address_nottingham
  end

  def expect_property_entities
    expect_entity_wg_grace
  end

  def expect_agent_address
    expect(page).to have_text '555'
    expect(page).to have_text 'The County Ground'
    expect(page).to have_text '68f'
    expect(page).to have_text 'Grandstand Road'
    expect(page).to have_text 'Derby'
    expect(page).to have_text 'Derbyshire'
    expect(page).to have_text 'DE21 6AF'
  end

  def expect_agent_entities
    expect(page).to have_text 'K J Barnett'
  end

  def expect_charges
    expect(page).to have_text 'Ground Rent'
    expect(page).to have_text 'Advance'
    expect(page).to have_text '£50.50'

    expect(page).to have_text '1st Jan'
  end
end
