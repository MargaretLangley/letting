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

end
