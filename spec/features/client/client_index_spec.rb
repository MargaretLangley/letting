require 'spec_helper'
require_relative '../shared/address'

describe Client do

  it '#index' do
    client_factory human_client_id: 101
    client_factory human_client_id: 102
    client_factory human_client_id: 103

    visit '/clients/'
    expect(current_path).to eq '/clients/'

    # shows multiple rows
    expect(page).to have_text '101'
    expect(page).to have_text '102'
    expect(page).to have_text '103'

    # displays multiple columns
    expect(page).to have_text 'W G'
    expect(page).to have_text 'Grace'
    expect(page).to have_text 'Edgbaston Road'
    expect(page).to have_text 'Birmingham'
  end

  def client_factory args = {}
    client = Client.new human_client_id: args[:human_client_id]
    client.build_address address_attributes
    client.entities.build person_entity_attributes
    client.save!
    client
  end
end