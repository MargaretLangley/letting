require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property do

  context '#update' do

    it 'basic' do
      property = property_factory id: 1, human_id: 8000
      navigate_to_edit_page
      validate_page
      expect_form_to_be
      fill_in_form
      update_then_expect_properties_page
      expect_property_data_changed
      navigate_to_property_view_page
      expect_property_updates
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
        end

        def expect_address_has_original_attributes
          within_fieldset 'property_address' do
            expect_address_edgbaston_by_field
          end
        end

        def expect_entity_has_original_attributes
          within_fieldset 'property_entity_0' do
            expect_entity_wg_grace_by_field
          end
        end

      def fill_in_form
        fill_in 'Property ID', with: '8001'
        fill_in_address
        fill_in_entity
      end

        def fill_in_client_address
          within_fieldset 'client_address' do
            fill_in_address_nottingham
          end
        end

        def fill_in_address
          within_fieldset 'property_address' do
            fill_in_address_nottingham
          end
        end

        def fill_in_entity
          within_fieldset 'property_entity_0' do
            fill_in_entity_dc_compto
          end
        end


      def update_then_expect_properties_page
        click_on 'Update Property'
        expect(current_path).to eq '/properties'
        expect(page).to have_text /property successfully updated!/i
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


    it 'basic with billing address' do
      property = property_factory_with_billing id: 1, human_id: 8000
      navigate_to_edit_page
      expect_bill_profile_has_original_attributes
      update_then_expect_properties_page
      navigate_to_property_view_page
      expect(page).to have_text 'Billing Address'
      expect(page).to have_text '33'
    end

      def expect_bill_profile_has_original_attributes
        expect(find_field('Use Agent')).to be_checked

        within_fieldset 'billing_profile' do
          expect(find_field('Flat no').value).to have_text '33'
        end
      end


    it 'add billing address', js:true do
      property = property_factory id: 1, human_id: 8000
      navigate_to_edit_page
      fill_in_bill_profile
      update_then_expect_properties_page
      navigate_to_property_view_page
      expect_new_bill_profile
    end

      def fill_in_bill_profile
        check_use_billing_profile
        fill_in_bill_profile_address
        fill_in_bill_profile_entity
      end

        def check_use_billing_profile
          within_fieldset 'billing_profile' do
            check 'Use Agent'
          end
        end

        def fill_in_bill_profile_address
          within_fieldset 'billing_profile' do
            fill_in 'Road', with: 'Middlesex Road'
            fill_in 'County', with: 'Greater London'
          end
        end

        def fill_in_bill_profile_entity
          within_fieldset 'billing_profile_entity_0' do
            fill_in 'Initials', with: 'G A R'
            fill_in 'Name', with: 'Lock'
          end
        end


      def expect_new_bill_profile
        expect(page).to have_text 'Middlesex Road'
        expect(page).to have_text 'G A R'
        expect(page).to have_text 'Lock'
      end




    it 'handles validation' do
      property_factory id: 1, human_id: 8000
      navigate_to_edit_page
      validate_page
      clear_address_road
      click_on 'Update Property'
      expect(current_path).to eq '/properties/1'
      expect(page).to have_text /The property could not be saved./i
    end

      def clear_address_road
        within_fieldset 'property_address' do
          fill_in 'Road', with: ''
        end
      end


    it 'removes billing address' do
      property_factory_with_billing id: 1, human_id: 8000
      navigate_to_edit_page
      uncheck 'Use Agent'
      update_then_expect_properties_page
      navigate_to_property_view_page
      expect(page).to have_text /Billing to property address/i
    end




    context '#charge' do

      it '#adds date charge' do
        property = property_factory id: 1, human_id: 8000
        navigate_to_edit_page
        fill_in_charge
        fill_in_due_on_on_date
        update_then_expect_properties_page
        navigate_to_property_view_page
        expect(page).to have_text 'Service Charge in Arrears'
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
          fill_in 'property_charges_attributes_0_due_ons_attributes_0_day', with: '5'
          fill_in 'property_charges_attributes_0_due_ons_attributes_0_month', with: '4'
        end


      it 'adds monthly charge', js: true do
        property = property_factory id: 1, human_id: 8000
        navigate_to_edit_page
        fill_in_charge
        fill_in_due_on_on_date
        update_then_expect_properties_page
        navigate_to_property_view_page
        expect(page).to have_text 'Service Charge in Arrears'
        expect(page).to have_text '£100.08'
      end

        def fill_in_due_on_every_month
          fill_in 'property_charges_attributes_0_due_ons_attributes_4_day', with: '5'
        end


      it 'opens a montly charge correctly', js: true do
        property = property_factory_with_monthly_charge id: 1, human_id: 8000
        binding.pry
        navigate_to_edit_page
        expect(page).to have_text 'every month or on date'
      end

      it 'opens monthly and changes to date charge', js: true do
        pending
      end
    end

    it 'can delete', js: true do
      property = property_factory_with_charge id: 1, human_id: 8000
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
