require 'spec_helper'

describe Property do

  it '#show' do
    property = property_factory id: 1, human_property_id: 1000
    visit '/properties/'
    click_on '1000'
    expect(current_path).to eq '/properties/1'
    expect_property_address

    expect(property.separate_billing_address?).to be_true
    expect_billing_address

    expect(page).to have_text 'Mr'
    expect(page).to have_text 'W G'
    expect(page).to have_text 'Grace'
  end


  def property_factory args = {}
    property = Property.new id: args[:id], human_property_id: args[:human_property_id]
    property.build_address address_attributes
    property.entities.build person_entity_attributes
    property.build_billing_profile use_profile: true
    property.billing_profile.build_address oval_address_attributes
    property.billing_profile.entities.build person_entity_attributes
    property.save!
    property
  end

  def expect_property_address
    expect(page).to have_text '1000'
    expect(page).to have_text '294'
    expect(page).to have_text 'Edgbaston Road'
    expect(page).to have_text 'Edgbaston'
    expect(page).to have_text 'Birmingham'
    expect(page).to have_text 'West Midlands'
    expect(page).to have_text 'B5 7QU'
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

end