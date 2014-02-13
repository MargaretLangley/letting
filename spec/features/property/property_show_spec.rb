require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property do

  before(:each) do
    log_in
    property_with_agent_create! id: 1, human_ref: 1000
    visit '/properties/'
    click_on 'View'
  end

  it '#show' do
    expect(current_path).to eq '/properties/1'
    expect_property_address
    expect_property_entity
    expect_agent_info
  end

  it 'navigates to index page' do
    click_on 'Accounts'
    expect(page).to have_text 'Actions'
    expect(page).to have_text 'Delete'
  end

  it 'navigates to edit page' do
    click_on 'Edit'
    expect(page).to have_text 'Title'
    expect(page).to have_text 'Postcode'
  end

  def expect_property_address
    expect(page).to have_text '1000'
    expect_address_edgbaston
  end

  def expect_property_entity
    expect_entity_wg_grace
  end

  def expect_agent_info
    expect_agent_address
    expect_agent_entity
  end

  def expect_agent_entity
    expect(page).to have_text 'Rev'
    expect(page).to have_text 'V. W.'
    expect(page).to have_text 'Knutt'
  end

  def expect_agent_address
    expect(page).to have_text '33'
    expect(page).to have_text 'The Oval'
    expect(page).to have_text '207b'
    expect(page).to have_text 'Vauxhall Street'
    expect(page).to have_text 'Kennington'
    expect(page).to have_text 'London'
    expect(page).to have_text 'Greater London'
    expect(page).to have_text 'SE11 5SS'
  end
end

describe Property do

  before(:each) do
    log_in
    property_create! human_ref: 111
    property_create! human_ref: 222
    visit '/properties/'
    first(:link, 'View').click
  end

  it 'searches for valid property' do
    pending 'search'
    fill_in 'search', with: '222'
    click_on 'Search'
    expect(page).to have_text 'Edgbaston Road'
  end

  it 'searches for same property' do
    pending 'search'
    fill_in 'search', with: '222'
    click_on 'Search'
    fill_in 'search', with: '222'
    click_on 'Search'
    expect(page).to have_text 'Edgbaston Road'
  end

  it 'search not found' do
    pending 'search'
    fill_in 'search', with: '599'
    click_on 'Search'
    expect(page).to_not have_text '599'
  end

end
