require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Client do

  before(:each) do
    log_in
    client_create!.properties << property_new
  end

  it '#show' do
    visit '/clients/'
    click_on 'View'
    expect_client_entity
    expect_client_address
    expect_property
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
