require 'rails_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property, type: :feature do

  before(:each) do
    log_in
    property_with_agent_create id: 1, human_ref: 1000
    visit '/properties/'
    find('.view-testing-link', visible: false).click
  end

  it '#show' do
    expect(current_path).to eq '/properties/1'
    expect_property_address
    expect_property_entity
    expect_agent_info
  end

  # pending
  it 'should show dormant as no charges levied'
  # expect(page).to have_text 'No charges levied against this property.'

  it 'navigates to index page' do
    click_on 'Accounts'
    expect(page.title).to eq 'Letting - Accounts'
  end

  it 'navigates to edit page' do
    first(:link, 'Edit').click
    expect(page.title).to eq 'Letting - Edit Account'
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
