require 'spec_helper'

describe Property do

  it '#updates' do
    navigate_to_edit_page
    validate_on_edit_page
    expect_form_to_be
    fill_in_form
    click_on 'Update Property'

    expect_properties

    visit '/properties/1'
    expect_property_updates
  end

  it '#update handles validation' do
    navigate_to_edit_page
    validate_on_edit_page
    check_use_billing_profile
    clear_address_road
    click_on 'Update Property'
    expect(current_path).to eq '/properties/1'
    expect(page).to have_text 'The property could not be saved.'
  end



  def property_factory args = {}
    property = Property.new id: args[:id], human_property_reference: args[:human_property_reference]
    property.build_address address_attributes
    property.entities.build person_entity_attributes
    property.build_billing_profile use_profile: true
    property.billing_profile.build_address oval_address_attributes
    property.billing_profile.entities.build oval_person_entity_attributes
    property.save!
    property
  end

  def navigate_to_edit_page
    property = property_factory id: 1, human_property_reference: 8000
    visit '/properties'
    click_on 'Edit'
  end

  def validate_on_edit_page
    expect(current_path).to eq '/properties/1/edit'
  end

  def expect_form_to_be
    expect_property_has_original_attributes
    expect_address_has_original_attributes
    expect_entity_has_original_attributes
    expect_bill_profile_has_original_attributes
  end

    def expect_property_has_original_attributes
      expect(find_field('property_human_property_reference').value).to have_text '8000'
    end

    def expect_address_has_original_attributes
      within_fieldset 'property_address' do
        expect(find_field('Flat no').value).to have_text '47'
        expect(find_field('House name').value).to have_text 'Sunny Views'
        expect(find_field('Road no').value).to have_text '10a'
        expect(find_field('Road').value).to have_text 'High Street'
        expect(find_field('District').value).to have_text 'Kingswindford'
        expect(find_field('Town').value).to have_text 'Dudley'
        expect(find_field('County').value).to have_text 'West Midlands'
        expect(find_field('Postcode').value).to have_text 'DY6 7RA'
      end
    end

    def expect_entity_has_original_attributes
      within_fieldset 'property_entity_0' do
        expect(find_field('Title').value).to have_text 'Mr'
        expect(find_field('Initials').value).to have_text 'X Z'
        expect(find_field('Name').value).to have_text 'Ziou'
      end
    end

    def expect_bill_profile_has_original_attributes
      within_fieldset 'billing_profile' do
        # As long as text for one field is right we know the
        # partial already works in other address code
        expect(find_field('Flat no').value).to have_text '33'
      end
    end

    def expect_property_data_changed
      expect(page).to_not have_text '8000'
      expect(page).to have_text '8001'
      expect(page).to_not have_text '10a'
      expect(page).to have_text '11c'
    end



  def fill_in_form
    fill_in_address
    fill_in_entity
    fill_in_bill_profile
  end

    def fill_in_address
        fill_in 'property_human_property_reference', with: '8001'
      within_fieldset 'property_address' do
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
      within_fieldset 'property_entity_0' do
        fill_in 'Title', with: 'Dr'
        fill_in 'Initials', with: 'B M'
        fill_in 'Name', with: 'Zeperello'
      end
    end

    def fill_in_bill_profile
      check_use_billing_profile
      fill_in_bill_profile_address
      fill_in_bill_profile_entity
    end

      def check_use_billing_profile
        within_fieldset 'billing_profile' do
          check 'Use profile'
        end
      end

      def fill_in_bill_profile_address
        within_fieldset 'billing_profile' do
          fill_in 'Road', with: 'Middlesex Road'
        end
      end

      def fill_in_bill_profile_entity
        within_fieldset 'property_billing_profile_entity_0' do
          fill_in 'Initials', with: 'G A R'
          fill_in 'Name', with: 'Lock'
        end
      end

  def clear_address_road
    within_fieldset 'property_address' do
      fill_in 'Road', with: ''
    end
  end


  def expect_properties
    expect(current_path).to eq '/properties'
    expect(page).to have_text 'Property successfully updated!'
    expect_property_data_changed
  end



  def expect_property_updates
    expect_new_address
    expect_new_entity
    expect_new_bill_profile
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

    def expect_new_bill_profile
      expect(page).to have_text 'Middlesex Road'
      expect(page).to have_text 'G A R'
      expect(page).to have_text 'Lock'
    end

end