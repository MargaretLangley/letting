require 'spec_helper'

describe Client do

  it '#index' do
    client_factory human_id: 101
    client_factory human_id: 102
    client_factory human_id: 103

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

  it '#index search' do
    client_factory human_id: 111,
              address_attributes: { road: 'Vauxall Lane' }
    client_factory human_id: 222
    client_factory human_id: 333

    visit '/clients'

    fill_in 'search', with: 'Edgbaston Road'
    click_on 'Search'
    expect(page).to_not have_text '111'
    expect(page).to have_text '222'
    expect(page).to have_text '333'
  end




  def client_factory args = {}
    client = Client.new human_id: args[:human_id]
    client.build_address address_attributes
    client.entities.build person_entity_attributes
    client.save!
    client
  end
end