require 'rails_helper'

describe Property, type: :feature   do
  before(:each) { log_in }

  it 'shows record' do
    property_create id: 1,
                    human_ref: 1000,
                    agent: agent_new(entities: [Entity.new(name: 'Bell')],
                                     address: address_new(road: 'Wiggiton')),
                    account: account_new,
                    client: client_new
    visit '/accounts/1'
    expect(page.title).to eq 'Letting - View Account'
    expect_property entity: 'Mr W. G. Grace'
    expect_agent_info entity: 'Bell', road: 'Wiggiton'
  end

  def expect_property entity: entity
    expect(page).to have_text entity
    expect(page).to have_text '1000'
    expect(page).to have_text 'Edgbaston'
  end

  def expect_agent_info entity: entity, road: road
    expect(page).to have_text entity
    [road].each do |line|
      expect(page).to have_text line
    end
  end

  it 'shows when charged' do
    charge = charge_create(charge_type: 'Rent')
    property_create id: 1,
                    account: account_new(charges: [charge]),
                    client: client_new
    visit '/accounts/1'
    expect(page).to have_text 'Rent'
  end

  it 'shows charges as dormant' do
    property_create id: 1,
                    account: account_new(charges: [charge_new(dormant: true)]),
                    client: client_new
    visit '/accounts/1'
    within 'div#charge' do
      expect(page).to have_text 'Yes'
    end
  end

  it 'navigates to index page' do
    property_create id: 1, account: account_new, client: client_new
    visit '/accounts/1'
    click_on 'Accounts'
    expect(page.title).to eq 'Letting - Accounts'
  end

  it 'navigates to edit page' do
    property_create id: 1, account: account_new, client: client_new
    visit '/accounts/1'
    first(:link, 'Edit').click
    expect(page.title).to eq 'Letting - Edit Account'
  end

  describe 'no charges message' do
    it 'displays message when account has no charges' do
      property_create id: 1,
                      account: account_new(charges: []),
                      client: client_new
      visit '/accounts/1'

      expect(page.text).to match /No charges levied against this property./i
    end

    it 'hides message when client has properties' do
      property_create id: 1,
                      account: account_new(charges: [charge_new]),
                      client: client_new
      visit '/accounts/1'

      expect(page.text).to_not match /No charges levied against this property./i
    end
  end
end
