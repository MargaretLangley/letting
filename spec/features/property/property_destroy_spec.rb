require 'spec_helper'

describe Property do

  it '#destroys a property' do
    property_factory human_property_reference: 9000
    visit '/properties'
    expect(page).to have_text 'High Street'
    expect{ click_on 'Delete'}.to change(Property, :count).by -1
    expect(page).not_to have_text 'High Street'
    expect(page).to have_text 'Property successfully deleted!'
  end


  def property_factory args = {}
    property = Property.create! human_property_reference: args[:human_property_reference]
    property.create_address! address_attributes
    property.entities.create! person_entity_attributes
    property
  end
end