require 'spec_helper'

describe Property do


  it 'listed' do
    property1 = Property.create! human_property_reference: 111
    property1.addresses.create! address_attributes

    property2 = Property.create! human_property_reference: 222
    property2.addresses.create! address_attributes

    property3 = Property.create! human_property_reference: 333
    property3.addresses.create! address_attributes

    visit '/properties/'
    # shows more than one row
    expect(page).to have_text '111'
    expect(page).to have_text '222'

    # Displays expected columns
    expect(page).to have_text '333'
    expect(page).to have_text 'High Street'
    expect(page).to have_text 'Dudley'
    expect(page).to have_text 'DY6 7RA'

  end
end
