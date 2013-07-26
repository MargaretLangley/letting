require 'spec_helper'

describe Property do


  it 'listed' do
    Property.create! human_property_reference: 777
    Property.create! human_property_reference: 898
    Property.create! human_property_reference: 8008
    visit '/properties/'
    expect(page).to have_text '777'
    expect(page).to have_text '898'
    expect(page).to have_text '8008'
  end
end
