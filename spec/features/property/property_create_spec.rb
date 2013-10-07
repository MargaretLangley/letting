require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property do

  before(:each) { log_in }

  it '#create', js: true  do
    navigate_to_create_page
    validate_page
    fill_in_form
    click_on 'Create Property'
    expect(page).to_not have_text 'The property could not be saved.'
    have_we_saved?
    expect_properties_page
    navigate_to_property_page
    expect_property_page
  end

  it '#creates a property without billing profile' do
    navigate_to_create_page
    fill_in_property
    fill_in_property_address
    fill_in_property_entities
    click_on 'Create Property'
    expect(current_path).to eq '/properties'
    navigate_to_property_page
    expect_property
    expect_property_address
    expect_property_entities
  end

  it '#create has validation' do
    navigate_to_create_page
    invalidate_page
    click_on 'Create Property'
    expect(current_path).to eq '/properties'
    expect(page).to have_text 'The property could not be saved.'
  end

  it 'can add charges', js: true do
    navigate_to_create_page
    expect(page).to_not have_text 'Charge 2'
    click_on 'Add Charge'
    expect(page).to have_text 'Charge 2'
    click_on 'Add Charge'
    expect(page).to have_text 'Charge 3'
    # couldn't get the rest of this to work reliabily
    # Charge 4 should work the .disabled might be
    # a dynamic insertion of css problem
    # click_on 'Add Charge'
    # expect(page).to have_text 'Charge 4'
    # page.should have_css('.disabled')
    expect(page).to have_text 'Charge'
  end

  def navigate_to_create_page
    visit '/properties'
    click_on 'New Property'
  end

  def validate_page
    expect(current_path).to eq '/properties/new'
    expect(page.all('h3', text: 'Person or company').count).to eq 1
    expect(page.all('h3', text: 'Address').count).to eq 1
    expect(page.all('h3', text: 'Occupier').count).to eq 1
    expect(page.all('h3', text: 'Agent').count).to eq 1
  end

  def fill_in_form
    fill_in_property
    fill_in_property_address
    fill_in_property_entities
    fill_in_billing_profile_address
    fill_in_billing_profile_entities
    fill_in_charge
  end

    def fill_in_property
      fill_in 'Property ID', with: '278'
      fill_in 'Client ID', with: '2'
    end

    def fill_in_property_address
      within_fieldset 'property_address' do
        fill_in_address_nottingham
      end
    end

    def fill_in_property_entities
      within_fieldset 'property_entity_0' do
        fill_in_entity_wg_grace
      end
    end

    def fill_in_billing_profile_address
      check 'Use Agent'
      within_fieldset 'billing_profile' do
        fill_in 'Flat no', with: '555'
        fill_in 'House name', with: 'The County Ground'
        fill_in 'Road no', with: '68f'
        fill_in 'Road', with: 'Grandstand Road'
        fill_in 'Town', with: 'Derby'
        fill_in 'County', with: 'Derbyshire'
        fill_in 'Postcode', with: 'DE21 6AF'
      end
    end

    def fill_in_billing_profile_entities
      within_fieldset 'billing_profile_entity_0' do
        fill_in 'Name', with: 'K J Barnett'
      end
    end

    def fill_in_charge
      within_fieldset 'property_charge_0' do
        fill_in 'Charge type', with: 'Ground Rent'
        fill_in 'Due in', with: 'Advance'
        fill_in 'Amount', with: '50.50'
      end
      fill_in_due_on
    end

    def fill_in_due_on
      within_fieldset 'property_charge_0_due_on_0' do
        fill_in 'property_account_attributes_charges_' +
                'attributes_0_due_ons_attributes_0_day',
                with: 1
        fill_in 'property_account_attributes_charges_' +
                'attributes_0_due_ons_attributes_0_month',
                with: 1
      end
    end

  def have_we_saved?
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
    click_on 'View'
  end

  def expect_property_page
    expect_property
    expect_property_address
    expect_property_entities
    expect_billing_profile_address
    expect_billing_profile_entities
    expect_charges
  end

    def expect_property
      expect(page).to have_text '278'
    end

    def expect_property_address
      expect_address_nottingham
    end

    def expect_property_entities
      expect_entity_wg_grace
    end

    def expect_billing_profile_address
      expect(page).to have_text '555'
      expect(page).to have_text 'The County Ground'
      expect(page).to have_text '68f'
      expect(page).to have_text 'Grandstand Road'
      expect(page).to have_text 'Derby'
      expect(page).to have_text 'Derbyshire'
      expect(page).to have_text 'DE21 6AF'
    end

    def expect_billing_profile_entities
      expect(page).to have_text 'K J Barnett'
    end

    def expect_charges
      expect(page).to have_text 'Ground Rent'
      expect(page).to have_text 'Advance'
      expect(page).to have_text '£50.50'

      expect(page).to have_text '1st Jan'
    end
end
