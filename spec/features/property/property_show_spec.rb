require 'rails_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property, type: :feature do

  before(:each) { log_in }

  it 'shows record' do
    property_with_agent_create id: 1, human_ref: 1000
    visit '/properties/1'
    expect(page.title).to eq 'Letting - View Account'
    expect_property_address
    expect_property_entity
    expect_agent_info
  end

  it 'shows when charged' do
    property_with_charge_create(id: 1, charge: charge_create(
             charge_structure: charge_structure_create(id: 1)))
    visit '/properties/1'
    expect(page).to have_text 'Ground Rent'
  end

  # pending
  it 'should show dormant as no charges levied'
  # expect(page).to have_text 'No charges levied against this property.'

  it 'navigates to index page' do
    property_with_agent_create id: 1, human_ref: 1000
    visit '/properties/1'
    click_on 'Accounts'
    expect(page.title).to eq 'Letting - Accounts'
  end

  it 'navigates to edit page' do
    property_with_agent_create id: 1, human_ref: 1000
    visit '/properties/1'
    first(:link, 'Edit').click
    expect(page.title).to eq 'Letting - Edit Account'
  end

  def expect_property_address
    expect(page).to have_text '1000'
    expect_address_edgbaston
  end

  def expect_property_entity
    expect(page).to have_text 'Mr W. G. Grace'
  end

  def expect_agent_info
    expect_agent_entity
    expect_agent_address
  end

  def expect_agent_entity
    expect(page).to have_text 'Rev V. W. Knutt'
  end

  def expect_agent_address
    ['33',
     'The Oval',
     '207b',
     'Vauxhall Street',
     'Kennington',
     'London',
     'Greater London',
     'SE11 5SS'].each do |line|
      expect(page).to have_text line
    end
  end
end
