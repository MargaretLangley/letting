require 'spec_helper'
################################
# Account Page
#
# Encapsulates the Account Page (new and edit)
#
# The layer hides the capybara calls to make the functional rspec tests that
# use this class simpler.
#
# Due to Address methods
# rubocop: disable Style/ParameterLists
# rubocop: disable Style/MethodLength
#
# Temporary until start_date / end_date used
# rubocop: disable Lint/UnusedMethodArgument
#
class AccountPage
  include Capybara::DSL

  def new
    visit '/properties/new'
    self
  end

  def edit
    visit '/properties/'
    click_on 'Edit'
    self
  end

  def button action
    click_on "#{action} Account"
    self
  end

  def click(choice)
    click_on choice
  end

  def expect_property(spec, property_id:, client_id:)
    spec.expect(find_field('Property ID').value).to spec.have_text property_id
    spec.expect(find_field('property_client_ref').value).to spec.have_text \
      client_id
  end

  def property(spec, property_id:, client_id:)
    fill_in 'Property ID', with: property_id
    spec.fill_autocomplete('property_client_ref', with: client_id)
  end

  def expect_entity(spec, type:, order: 0, title:, initials:, name:)
    id_stem = "#{type}_entities_attributes_#{order}"
    spec.expect(find_field("#{id_stem}_title").value).to spec.have_text title
    spec.expect(find_field("#{id_stem}_initials").value).to \
      spec.have_text initials
    spec.expect(find_field("#{id_stem}_name").value).to spec.have_text name
  end

  def entity(type:, order: 0, title:, initials:, name:)
    id_stem = "#{type}_entities_attributes_#{order}"
    fill_in "#{id_stem}_title", with: title
    fill_in "#{id_stem}_initials", with: initials
    fill_in "#{id_stem}_name", with: name
  end

  def expect_address(spec, type:, flat_no: '', house_name: '', road_no: '',
                     road: '', town: '', district: '', county: '', postcode: ''
                    )
    within type do
      spec.expect(find_field('Flat no').value).to spec.have_text flat_no
      spec.expect(find_field('House name').value).to spec.have_text house_name
      spec.expect(find_field('Road no').value).to spec.have_text road_no
      spec.expect(find_field('Road').value).to spec.have_text road
      spec.expect(find_field('Town').value).to spec.have_text town
      spec.expect(find_field('District').value).to spec.have_text district \
        if district.present?
      spec.expect(find_field('County').value).to spec.have_text county
      spec.expect(find_field('Postcode').value).to spec.have_text postcode
    end
  end

  def address(selector:,
              flat_no: '',
              house_name: '',
              road_no:,
              road:,
              town:,
              district: '',
              county:,
              postcode:)
    within selector do
      fill_in 'Flat no', with: flat_no
      fill_in 'House name', with: house_name
      fill_in 'Road no', with: road_no
      fill_in 'Road', with: road
      fill_in 'District', with: district if district.present?
      fill_in 'Town', with: town
      fill_in 'County', with: county
      fill_in 'Postcode', with: postcode
    end
  end

  # create rows used by charge during select
  # Must occur before opening page
  #
  def charge_initialization(charge_cycle:, charged_in:)
    charge_cycle_create(name: charge_cycle)
    charged_in_create(name: charged_in)
  end

  def charge(order: 0, charge_type:, charge_structure_id:, charge_cycle:,
             charged_in:, amount:, start_date: '', end_date: '')
    id_stem = "property_account_attributes_charges_attributes_#{order}"
    fill_in "#{id_stem}_charge_type", with: charge_type
    select(charge_cycle, from: "charge_cycle_#{order}")
    # Not selecting - probably because the initalization process
    # isn't leaving the options group
    # select(charged_in, from: "#{id_stem}_charge_structure_id")
    fill_in "#{id_stem}_amount", with: amount
    # fill_in "#{id_stem}_start_date", with: start_date if start_date.present?
    # fill_in "#{id_stem}_end_date", with: start_date if end_date.present?
  end

  def expect_charge(spec, order: 0, charge_type:, charge_structure_id:,
                    charged_in:, amount:, start_date: '', end_date: '')
    id_stem = "property_account_attributes_charges_attributes_#{order}"
    spec.expect(find_field("#{id_stem}_charge_type").value).to \
      spec.have_text charge_type
    spec.expect(find_field("charge_cycle_#{order}")).to \
      spec.have_text('Mar/Sep')
    spec.expect(find_field("#{id_stem}_amount").value).to spec.have_text amount
  end

  def successful?(spec)
    spec.expect(page.title).to spec.eq 'Letting - Accounts'
    spec.expect(page).to spec.have_text 'successfully'
    self
  end
end
