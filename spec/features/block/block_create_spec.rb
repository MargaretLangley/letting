require 'spec_helper'

describe Block do

  it '#create a block' do
    navigate_to_create_page
  end

  def navigate_to_create_page
      p1 = property_factory human_property_id: 3001,
                   address_attributes: { flat_no: 1, house_name: 'Hillbank House' }
      p2 = property_factory human_property_id: 3002,
                   address_attributes: { flat_no: 2, house_name: 'Hillbank House' }
      p3 = property_factory human_property_id: 3003,
                   address_attributes: { flat_no: 3, house_name: 'Hillbank House' }
    visit '/blocks/'
    click_on 'Add New Block'
    expect(current_path).to eq '/blocks/new'
    fill_in 'search', with: 'Hillbank House'
    click_on 'Search'
    expect(page).to have_text 'Hillbank House'
  end

end