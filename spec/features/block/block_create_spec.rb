require 'spec_helper'

describe Block do

  before(:each) do
    log_in
    create_properties
    navigate_to_create_page
    expect(current_path).to eq '/blocks/new'
  end

  it '#create a block' do
    find_block 'Hillbank House'
    expect(page).to have_text 'Hillbank House'
    expect { click_on 'Save block' }.to change(Block, :count).by 1
    expect(current_path).to eq '/blocks'
    expect(page).to have_text 'Block has been added!'
  end

  it '#handles unknown block' do
    find_block 'Unknown House'
    expect(page).to have_button 'Find properties'
    find_block 'Hillbank House'
    expect { click_on 'Save block' }.to change(Block, :count).by 1
  end

  def create_properties
    property_create! human_ref: 31, address_attributes: { flat_no: 1 }
    property_create! human_ref: 32, address_attributes: { flat_no: 2 }
    property_create! human_ref: 33, address_attributes: { flat_no: 3 }
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
