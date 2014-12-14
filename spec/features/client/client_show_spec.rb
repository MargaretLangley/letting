require 'rails_helper'

describe Client, type: :feature do

  before(:each) { log_in }

  it '#show' do
    credit = credit_new on_date: '2014-3-1', charge: charge_create
    client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
      .properties << property_new(human_ref: 2008,
                                  account: account_new(credits: [credit]))

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

  it 'displays message when no properties under client' do
    client_create
    visit '/clients/'
    find('.view-testing-link', visible: false).click
    expect(page).to have_text 'The Client has no tenants.'
  end
end
