require 'spec_helper'
require_relative '../shared/address'

describe Property do

  it '#show' do
    property = property_factory id: 1, human_property_id: 1000
    visit '/properties/'
    click_on '1000'
    expect(current_path).to eq '/properties/1'
    expect_property_address
    expect_property_entity

    expect(property.separate_billing_address?).to be_true
    expect_billing_address
    expect_billing_entity
  end


  def property_factory args = {}
    property = Property.new id: args[:id], human_property_id: args[:human_property_id]
    property.build_address address_attributes
    property.entities.build person_entity_attributes
    property.build_billing_profile use_profile: true
    property.billing_profile.build_address oval_address_attributes
    property.billing_profile.entities.build oval_person_entity_attributes
    property.save!
    property
  end

  def expect_property_address
    expect(page).to have_text '1000'
    expect_address_edgbaston
  end

  def expect_property_entity
    expect(page).to have_text 'Mr'
    expect(page).to have_text 'W G'
    expect(page).to have_text 'Grace'
  end

  def expect_billing_address
    expect(page).to have_text '33'
    expect(page).to have_text 'The Oval'
    expect(page).to have_text '207b'
    expect(page).to have_text 'Vauxhall Street'
    expect(page).to have_text 'Kennington'
    expect(page).to have_text 'London'
    expect(page).to have_text 'Greater London'
    expect(page).to have_text 'SE11 5SS'
  end

  def expect_billing_entity
    expect(page).to have_text 'Rev'
    expect(page).to have_text 'V W'
    expect(page).to have_text 'Knutt'
  end

end