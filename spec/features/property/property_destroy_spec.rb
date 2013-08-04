require 'spec_helper'

describe Property do

  it '#destroys a property' do
    property_factory human_property_id: 9000
    visit '/properties'
    expect(page).to have_text 'Edgbaston Road'
    expect{ click_on 'Delete'}.to change(Property, :count).by -1
    expect(page).not_to have_text 'Edgbaston Road'
    expect(page).to have_text 'Property successfully deleted!'
  end


  def property_factory args = {}
    property = Property.new human_property_id: args[:human_property_id]
    property.build_address address_attributes
    property.entities.build person_entity_attributes
    property.save!
    property
  end
end