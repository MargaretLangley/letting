require 'rails_helper'

describe Client, type: :feature do

  before(:each) do
    log_in
    client_create(
       human_ref: 8008,
       entities: [Entity.new(title: 'Mr', initials: 'W G', name: 'Grace')])
      .properties << property_new
    visit '/clients/'
    find('.view-testing-link', visible: false).click
  end

  it '#show' do
    expect_client_entity
    expect_client_address
    expect_property
  end

  it 'navigates to index page' do
    click_on 'Clients'
    expect(page.title).to eq 'Letting - Clients'
  end

  it 'navigates to edit page' do
    click_on 'Edit'
    expect(page.title).to eq 'Letting - Edit Client'
  end

  def expect_client_address
    expect(page).to have_text '8008'
    expect_address_edgbaston
  end

  def expect_client_entity
    expect(page).to have_text 'Mr'
    expect(page).to have_text 'W. G.'
    expect(page).to have_text 'Grace'
  end

  def expect_property
    expect(page).to have_text '2002'
  end

  def expect_address_edgbaston
    expect_index_address
    [
      'Edgbaston',      # district
      'West Midlands',  # county
      'B5 7QU'          # postcode
    ].each do |line|
      expect(page).to have_text line
    end
  end

  def expect_index_address
    [
      '47',             # Flat No
      'Hillbank House', # House Name
      '294',            # House No
      'Edgbaston Road', # Road
      'Birmingham'      # Town
    ].each do |line|
      expect(page).to have_text line
    end
  end
end
