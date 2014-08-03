require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Client, type: :feature do

  before(:each) do
    log_in
    client_create!.properties << property_new
    visit '/clients/'
    click_on 'View'
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
    expect_entity_wg_grace
  end

  def expect_property
    expect(page).to have_text '2002'
  end

end
