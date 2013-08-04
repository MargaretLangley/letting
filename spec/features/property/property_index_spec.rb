require 'spec_helper'

describe Property do

  it '#index' do
    property_factory human_property_id: 111
    property_factory human_property_id: 222
    property_factory human_property_id: 333

    visit '/properties/'
    # shows more than one row
    expect(page).to have_text '111'
    expect(page).to have_text '222'

    # Displays expected columns
    expect(page).to have_text '333'
    expect(page).to have_text '294'
    expect(page).to have_text 'Edgbaston Road'
    expect(page).to have_text 'Birmingham'
    expect(page).to have_text 'B5 7QU'
  end


  def property_factory args = {}
    property = Property.new human_property_id: args[:human_property_id]
    property.build_address address_attributes
    property.entities.build person_entity_attributes
    property.save!
    property
  end
end
