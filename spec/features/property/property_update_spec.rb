require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property, type: :feature do

  context '#update' do

    before(:each) { log_in }

    it 'basic', js: true do
      client = client_create!
      property_create! id: 1, human_ref: 8000, client_id: client.id
      client_create! human_ref: 8010
      navigate_to_edit_page
      validate_page
      expect_form_to_be
      fill_in_form
      update_then_expect_properties_page
      expect_property_data_changed
      navigate_to_property_view_page
      click_on 'Full Property'
      expect_property_updates
    end

    it 'navigates to index page' do
      property_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      click_on 'Accounts'
      expect(page.title).to eq 'Letting - Accounts'
    end

    it 'navigates to accounts view page' do
      property_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      click_on 'View file'
      expect(page.title).to eq 'Letting - View Account'
    end

    def navigate_to_edit_page
      visit '/properties/'
      click_on 'Edit'
    end

    def validate_page
      expect(current_path).to eq '/properties/1/edit'
    end

    def expect_form_to_be
      expect_property_has_original_attributes
      expect_address_has_original_attributes
      expect_entity_has_original_attributes
    end

    def expect_property_has_original_attributes
      expect(find_field('Property ID').value).to have_text '8000'
      expect(find_field('Client Id').value).to have_text '8008'
    end

    def expect_address_has_original_attributes
      within_fieldset 'property' do
        expect_address_edgbaston_by_field
      end
    end

    def expect_entity_has_original_attributes
      within '#property_entity_0' do
        expect_entity_wg_grace_by_field2
      end
    end

    def expect_entity_wg_grace_by_field2
      id_stem = 'property_entities_attributes_0'
      expect(find_field("#{id_stem}_title").value).to have_text 'Mr'
      expect(find_field("#{id_stem}_initials").value).to have_text 'W G'
      expect(find_field("#{id_stem}_name").value).to have_text 'Grace'
    end

    def fill_in_form
      fill_in 'Property ID', with: '8001'
      fill_autocomplete('property_client_ref', with: '8010')
      fill_in_address
      fill_in_entity
    end

    def fill_in_client_address
      within_fieldset 'client' do
        fill_in_address_nottingham
      end
    end

    def fill_in_address
      within_fieldset 'property' do
        fill_in_address_nottingham
      end
    end

    def fill_in_entity
      within '#property_entity_0' do
        fill_in_entity_dc_compto2
      end
    end

    # Eventually method will be in shared/entity
    def fill_in_entity_dc_compto2
      id_stem = 'property_entities_attributes_0'
      fill_in "#{id_stem}_title", with: 'Mr'
      fill_in "#{id_stem}_initials", with: 'D C S'
      fill_in "#{id_stem}_name", with: 'Compton'
    end

    def update_then_expect_properties_page
      click_on 'Update Account'
      expect(current_path).to eq '/properties'
      expect(page).to have_text 'successfully updated!'
    end

    def expect_property_data_changed
      expect(page).to_not have_text '8000'
      expect(page).to have_text '8001'
      expect(page).to_not have_text '294'
      expect(page).to have_text '471'
    end

    def navigate_to_property_view_page
      visit '/properties/1'
    end

    def expect_property_updates
      expect_new_address
      expect_new_entity
    end

    def expect_new_address
      expect_address_nottingham
    end

    def expect_new_entity
      expect_entity_dc_compton
    end

    it 'basic with agent address' do
      property_with_agent_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      expect_agent_has_original_attributes
      update_then_expect_properties_page
      navigate_to_property_view_page
      expect(page).to have_text 'Rev V. W. Knutt'
      expect(page).to have_text '33'
    end

    def expect_agent_has_original_attributes
      expect(find_field('Agent')).to be_checked
      within '#agent' do
        expect(find_field('Flat no').value).to have_text '33'
      end
    end

    it 'add agent address', js: true do
      property = property_create! human_ref: 8000
      navigate_to_edit_page
      fill_in_agent
      update_then_expect_properties_page
      navigate_view_by_property property
      click_on 'Full Property'
      expect_new_agent
    end

    def navigate_view_by_property property
      visit "/properties/#{property.id}"
    end

    def fill_in_agent
      check_use_agent
      fill_in_agent_address
      fill_in_agent_entity
    end

    def check_use_agent
      within '#agent' do
        check 'Agent'
      end
    end

    def fill_in_agent_address
      within '#agent' do
        fill_in 'Road', with: 'Middlesex Road'
        fill_in 'County', with: 'Greater London'
      end
    end

    def fill_in_agent_entity
      id_stem = 'property_agent_attributes_entities_attributes_0'
      within '#agent_entity_0' do
        fill_in "#{id_stem}_name", with: 'Lock'
      end
    end

    def expect_new_agent
      expect(page).to have_text 'Middlesex Road'
      expect(page).to have_text 'Lock'
    end

    it 'has validation' do
      property_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      validate_page
      clear_address_road
      click_on 'Update Account'
      expect(current_path).to eq '/properties/1'
      expect(page).to have_text /The property could not be saved./i
    end

    def clear_address_road
      within '#property_address' do
        fill_in 'Road', with: ''
      end
    end

    it 'removes agent address' do
      property_with_agent_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      uncheck 'Agent'
      update_then_expect_properties_page
      navigate_to_property_view_page
      expect(page).to have_text /None/i
    end

    context 'charge' do

      it 'adds date charge' do
        property_create! id: 1, human_ref: 8000
        navigate_to_edit_page
        fill_in_charge
        fill_in_due_on_on_date
        update_then_expect_properties_page
        navigate_to_property_view_page
        expect(page).to have_text 'Service Charge'
        expect(page).to have_text 'Arrears'
        expect(page).to have_text '£100.08'
      end

      def fill_in_charge
        within '#property_charge_0' do
          id_stem = 'property_account_attributes_charges_attributes_0'
          fill_in "#{id_stem}_charge_type", with: 'Service Charge'
          fill_in "#{id_stem}_due_in", with: 'Arrears'
          fill_in "#{id_stem}_amount", with: '100.08'
        end
      end

      def fill_in_due_on_on_date
        fill_in 'property_account_attributes_charges_' \
                'attributes_0_due_ons_attributes_0_day',
                with: '5'
        fill_in 'property_account_attributes_charges_' \
                'attributes_0_due_ons_attributes_0_month',
                with: '4'
      end

      it 'adds monthly charge', js: true do
        property_create! id: 1, human_ref: 8000
        navigate_to_edit_page
        click_on 'or per month'
        fill_in_charge
        fill_in_due_on_per_month
        update_then_expect_properties_page
        navigate_to_property_view_page
        expect(page).to have_text 'Service Charge'
        expect(page).to have_text 'Arrears'
        expect(page).to have_text '£100.08'
      end

      def fill_in_due_on_per_month
        fill_in 'property_account_attributes_charges_' \
                'attributes_0_due_ons_attributes_4_day',
                with: '5'
      end

      it 'opens a monthly charge correctly' do
        property_with_monthly_charge_create! human_ref: 8000
        navigate_to_edit_page
        expect(page).to have_text 'or on date'
      end

      it 'opens monthly and changes to date charge', js: true do
        property_with_monthly_charge_create! human_ref: 8000
        navigate_to_edit_page
        click_on 'or on date'
        expect(page).to have_text /or per month/i
      end
    end

    it 'deletes', js: true do
      property_with_charge_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      expect(page).to have_css('.spec-charge-count', count: 1)
      dormant_checkbox =
      '//*[@id="property_account_attributes_charges_attributes_0_dormant"]'
      find(:xpath, dormant_checkbox).set(true)
      update_then_expect_properties_page
      navigate_to_edit_page
      expect(find(:xpath, dormant_checkbox)).to be_checked
    end
  end

  def expect_charge_has_original_attributes
    within_fieldset 'property_charge_0' do
      expect(find_field('Charge type').value).to have_text 'Ground Rent'
      expect(find_field('Due in').value).to have_text 'Advance'
      expect(find_field('Amount').value).to have_text '88.08'
    end
  end

end
