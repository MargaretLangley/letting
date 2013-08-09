require 'spec_helper'
require_relative '../shared/address'

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
    expect_index_address_edgbaston
  end

  def property_factory args = {}
    property = Property.new human_property_id: args[:human_property_id]
    property.build_address address_attributes
    property.entities.build person_entity_attributes
    property.save!
    property
  end
end
