require 'spec_helper'

describe Property do

  it '#destroys a property' do
    property = Property.create! human_property_reference: 9000
    property.create_address! address_attributes
    property.entities.create! person_entity_attributes
    visit '/properties'
    expect(page).to have_text 'High Street'
    expect{ click_on 'Delete'}.to change(Property, :count).by -1
    expect(page).not_to have_text 'High Street'
    expect(page).to have_text 'Property successfully deleted!'
  end
end