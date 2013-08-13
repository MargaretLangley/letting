require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Client do
  it '#show' do
    client = client_factory id: 1, human_id: 3008
    client.properties << property_factory(id: 1, human_id: 909)
    visit '/clients/'
    click_on '3008'
    expect(current_path).to eq '/clients/1'
    expect_client_address
    expect_client_entity
    expect_property
  end

  def expect_client_address
    expect(page).to have_text '3008'
    expect_address_edgbaston
  end

  def expect_client_entity
    expect_entity_wg_grace
  end

  def expect_property
    expect(page).to have_text '909'
  end

end