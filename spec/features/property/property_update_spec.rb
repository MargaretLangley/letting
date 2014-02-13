require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property do

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
      expect(page).to have_text 'Actions'
      expect(page).to have_text 'Delete'
    end

    it 'navigates to accounts view page' do
      pending property_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      click_on 'Accounts'
      expect(page).to have_text 'Address'
      expect(page).to_not have_text 'Title'
      expect(page).to_not have_text 'Delete'
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
      expect(find_field('Client Ref').value).to have_text '8008'
    end

    def expect_address_has_original_attributes
      within_fieldset 'property' do
        expect_address_edgbaston_by_field
      end
    end

    def expect_entity_has_original_attributes
      within '#property_entity_0' do
        expect_entity_wg_grace_by_field
      end
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
        fill_in_entity_dc_compto
      end
    end

    def update_then_expect_properties_page
      click_on 'Create/Update Account'
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
      expect_bill_profile_has_original_attributes
      update_then_expect_properties_page
      navigate_to_property_view_page
      expect(page).to have_text 'Rev V. W. Knutt'
      expect(page).to have_text '33'
    end

    def expect_bill_profile_has_original_attributes
      expect(find_field('Use Agent')).to be_checked

      within_fieldset 'agent' do
        expect(find_field('Flat no').value).to have_text '33'
      end
    end

    it 'add agent address', js: true do
      property = property_create! human_ref: 8000
      navigate_to_edit_page
      fill_in_bill_profile
      update_then_expect_properties_page
      navigate_view_by_property property
      click_on 'Full Property'
      expect_new_bill_profile
    end

    def navigate_view_by_property property
      visit "/properties/#{property.id}"
    end

    def fill_in_bill_profile
      check_use_agent
      fill_in_bill_profile_address
      fill_in_bill_profile_entity
    end

    def check_use_agent
      within_fieldset 'agent' do
        check 'Use Agent'
      end
    end

    def fill_in_bill_profile_address
      within_fieldset 'agent' do
        fill_in 'Road', with: 'Middlesex Road'
        fill_in 'County', with: 'Greater London'
      end
    end

    def fill_in_bill_profile_entity
      within '#agent_entity_0' do
        fill_in 'Name', with: 'Lock'
      end
    end

    def expect_new_bill_profile
      expect(page).to have_text 'Middlesex Road'
      expect(page).to have_text 'Lock'
    end

    it 'has validation' do
      property_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      validate_page
      clear_address_road
      click_on 'Create/Update Account'
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
      uncheck 'Use Agent'
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
        within_fieldset 'property_charge_0' do
          fill_in 'Charge type', with: 'Service Charge'
          fill_in 'Due in', with: 'Arrears'
          fill_in 'Amount', with: '100.08'
        end
      end

      def fill_in_due_on_on_date
        fill_in 'property_account_attributes_charges_' +
                'attributes_0_due_ons_attributes_0_day',
                with: '5'
        fill_in 'property_account_attributes_charges_' +
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
        fill_in 'property_account_attributes_charges_' +
                'attributes_0_due_ons_attributes_4_day',
                with: '5'
      end

      it 'opens a monthly charge correctly' do
        property_with_monthly_charge_create! human_ref: 8000
        navigate_to_edit_page
        expect(page).to have_text 'Per month or on date'
      end

      it 'opens monthly and changes to date charge', js: true do
        property_with_monthly_charge_create! human_ref: 8000
        navigate_to_edit_page
        click_on 'or on date'
        expect(page).to have_text /on date or per month/i
      end
    end

    it 'deletes', js: true do
      property_create! id: 1, human_ref: 8000
      navigate_to_edit_page
      expect(page).to have_text 'Charge 1'
      within_fieldset 'property_charge_0' do
        click_on 'X'
      end
      update_then_expect_properties_page
      navigate_to_property_view_page
      expect(page).to_not have_text 'Ground Rent'
      expect(page).to have_text 'No charges levied against this property.'
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

describe Property do

  before(:each) do
    log_in
    property_create! human_ref: 111
    property_create! human_ref: 222
    visit '/properties/'
    first(:link, 'Edit').click
    expect(find_field('Property ID').value).to have_text '111'
  end

  it 'searches for valid property' do
    pending
    fill_in 'search', with: '222'
    click_on 'Search'
    expect(find_field('Property ID').value).to have_text '222'
  end

  it 'search not found' do
    pending 'search'
    fill_in 'search', with: 'Not Matching'
    click_on 'Search'
    expect(page).to have_text 'No Accounts Found'
  end

end
