require 'spec_helper'

describe Property do

  it '#create' do
    navigate_to_create_page
    validate_page
    fill_in_form
    click_on 'Create Property'
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

  it '#create handles validation' do
    navigate_to_create_page
    invalidate_page
    click_on 'Create Property'
    expect(current_path).to eq '/properties'
    expect(page).to have_text 'The property could not be saved.'
  end


  def navigate_to_create_page
    visit '/properties'
    click_on 'New Property'
  end

  def validate_page
    expect(current_path).to eq '/properties/new'
    expect(page.all('h3', text: 'Address').count).to eq 2
    expect(page.all('h3', text: 'Person').count).to eq 4
  end

  def fill_in_form
    fill_in_property
    fill_in_property_address
    fill_in_property_entities
    fill_in_use_billing_profile
    fill_in_billing_profile_address
    fill_in_billing_profile_entities
  end

    def fill_in_property
      fill_in 'property_human_property_id', with: '278'
    end

    def fill_in_property_address
      within_fieldset 'property_address' do
        fill_in 'Flat no', with: '471'
        fill_in 'House name', with: 'Trent Bridge'
        fill_in 'Road no', with: '63c'
        fill_in 'Road', with: 'Radcliffe Road'
        fill_in 'District', with: 'West Bridgford'
        fill_in 'Town', with: 'Nottingham'
        fill_in 'County', with: 'Notts'
        fill_in 'Postcode', with: 'NG2 6AG'
      end
    end

    def fill_in_property_entities
      within_fieldset 'property_entity_0' do
        fill_in 'Title', with: 'Mr'
        fill_in 'Initials', with: 'D C S'
        fill_in 'Name', with: 'Compton'
      end
    end

    def fill_in_use_billing_profile
      within_fieldset 'billing_profile' do
        check 'Use profile'
      end
    end

    def fill_in_billing_profile_address
      within_fieldset 'billing_profile' do
        fill_in 'Flat no', with: '555'
        fill_in 'House name', with: 'The County Ground'
        fill_in 'Road no', with: '68f'
        fill_in 'Road', with: 'Grandstand Road'
        fill_in 'District', with: 'West Bridgford'
        fill_in 'Town', with: 'Derby'
        fill_in 'County', with: 'Derbyshire'
        fill_in 'Postcode', with: 'DE21 6AF'
      end
    end

    def fill_in_billing_profile_entities
      within_fieldset 'property_billing_profile_entity_0' do
        fill_in 'Title', with: 'Mr'
        fill_in 'Initials', with: 'K J'
        fill_in 'Name', with: 'Barnett'
      end
    end

  def invalidate_page
    fill_in_property
    fill_in_property_address
  end

  def expect_properties_page
    expect(current_path).to eq '/properties'
  end

  def navigate_to_property_page
    click_on '278'
  end

  def expect_property_page
    expect_property
    expect_property_address
    expect_property_entities
    expect_billing_profile_address
    expect_billing_profile_entities
  end

    def expect_property
      expect(page).to have_text '278'
    end

    def expect_property_address
      expect(page).to have_text '471'
      expect(page).to have_text 'Trent Bridge'
      expect(page).to have_text '63c'
      expect(page).to have_text 'Radcliffe Road'
      expect(page).to have_text 'West Bridgford'
      expect(page).to have_text 'Nottingham'
      expect(page).to have_text 'Notts'
      expect(page).to have_text 'NG2 6AG'
    end

    def expect_property_entities
      expect(page).to have_text 'Mr'
      expect(page).to have_text 'D C S'
      expect(page).to have_text 'Compton'
    end

    def expect_billing_profile_address
      expect(page).to have_text '555'
      expect(page).to have_text 'The County Ground'
      expect(page).to have_text '68f'
      expect(page).to have_text 'Grandstand Road'
      expect(page).to have_text 'West Bridgford'
      expect(page).to have_text 'Derby'
      expect(page).to have_text 'Derbyshire'
      expect(page).to have_text 'DE21 6AF'
    end

    def expect_billing_profile_entities
      expect(page).to have_text 'Mr'
      expect(page).to have_text 'K J'
      expect(page).to have_text 'Barnett'
    end

end