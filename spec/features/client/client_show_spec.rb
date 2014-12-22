require 'rails_helper'

describe 'Client Show', type: :feature do
  before(:each) { log_in }

  it '#show' do
    client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
      .properties << property_new(human_ref: 2008)

    visit '/clients/1'
    expect_client_entity
    expect_client_address
    expect_property
  end

  def expect_client_address
    expect(page).to have_text '87'
  end

  def expect_client_entity
    expect(page).to have_text 'Grace'
  end

  def expect_property
    expect(page).to have_text '2008'
  end

  it 'navigates to index page' do
    client_create id: 1
    visit '/clients/1'
    click_on 'Clients'
    expect(page.title).to eq 'Letting - Clients'
  end

  it 'navigates to edit page' do
    client_create id: 1
    visit '/clients/1'
    click_on 'Edit'
    expect(page.title).to eq 'Letting - Edit Client'
  end

  describe 'no properties message' do
    it 'displays message when client has no properties' do
      client_create id: 1
      visit '/clients/1'

      expect(page.text).to match(/The client has no properties./i)
    end

    it 'hides message when client has properties' do
      client_create id: 1, property: property_new
      visit '/clients/1'

      expect(page.text).to_not match(/The client has no properties./i)
    end
  end
end
