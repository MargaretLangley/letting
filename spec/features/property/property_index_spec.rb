require 'spec_helper'

describe Property do

  it '#index' do
    property_factory human_property_reference: 111
    property_factory human_property_reference: 222
    property_factory human_property_reference: 333

    visit '/properties/'
    # shows more than one row
    expect(page).to have_text '111'
    expect(page).to have_text '222'

    # Displays expected columns
    expect(page).to have_text '333'
    expect(page).to have_text '10a'
    expect(page).to have_text 'High Street'
    expect(page).to have_text 'Dudley'
    expect(page).to have_text 'DY6 7RA'
  end


  def property_factory attributes = {}
    property = Property.create! human_property_reference: attributes[:human_property_reference]
    property.create_address! address_attributes
    property
  end
end

