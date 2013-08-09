require 'spec_helper'

describe Block do



  it '#create a block' do
    create_properties
    navigate_to_create_page
    expect(current_path).to eq '/blocks/new'
    find_block 'Hillbank House'
    expect(page).to have_text 'Hillbank House'
    expect{click_on 'Save block'}.to change(Block, :count).by 1
    expect(current_path).to eq '/blocks'
    expect(page).to have_text 'Block has been added!'
  end

  it '#handles unknown block' do
    create_properties
    navigate_to_create_page
    find_block 'Unknown House'
    expect(page).to have_button 'Find properties'
    find_block 'Hillbank House'
    expect{click_on 'Save block'}.to change(Block, :count).by 1
  end

  def create_properties
    p1 = property_factory human_property_id: 3001,
                 address_attributes: { flat_no: 1, house_name: 'Hillbank House' }
    p2 = property_factory human_property_id: 3002,
                 address_attributes: { flat_no: 2, house_name: 'Hillbank House' }
    p3 = property_factory human_property_id: 3003,
                 address_attributes: { flat_no: 3, house_name: 'Hillbank House' }
  end

  def navigate_to_create_page
    visit '/blocks/'
    click_on 'Add New Block'
  end

  def find_block block_name
    fill_in 'block_name', with: block_name
    click_on 'Find properties'
  end





end