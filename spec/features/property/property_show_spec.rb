require 'rails_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property, type: :feature do

  before(:each) { log_in }

  it 'shows record' do
    property_create id: 1,
                    human_ref: 1000,
                    agent: agent_new(entities: [Entity.new(name: 'Bell')],
                                     address: address_new(road: 'Wiggiton')),
                    account: account_new
    visit '/properties/1'
    expect(page.title).to eq 'Letting - View Account'
    expect_property entity: 'Mr W. G. Grace'
    expect_agent_info entity: 'Bell', road: 'Wiggiton'
  end

  def expect_property entity: entity
    expect(page).to have_text entity
    expect(page).to have_text '1000'
    expect_address_edgbaston
  end

  def expect_agent_info entity: entity, road: road
    expect(page).to have_text entity
    [road].each do |line|
      expect(page).to have_text line
    end
  end

  it 'shows when charged' do
    charge = charge_create(charge_type: 'Rent')
    property_create id: 1, account: account_new(charge: charge)
    visit '/properties/1'
    expect(page).to have_text 'Rent'
  end

  it 'shows charges as dormant' do
    charge = charge_create(dormant: true)
    property_create id: 1, account: account_new(charge: charge)
    visit '/properties/1'
    expect(page).to have_css '.dormant'
  end

  it 'navigates to index page' do
    property_create id: 1, account: account_new
    visit '/properties/1'
    click_on 'Accounts'
    expect(page.title).to eq 'Letting - Accounts'
  end

  it 'navigates to edit page' do
    property_create id: 1, account: account_new
    visit '/properties/1'
    first(:link, 'Edit').click
    expect(page.title).to eq 'Letting - Edit Account'
  end
end
