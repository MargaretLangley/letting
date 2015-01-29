require 'rails_helper'

#
# Property's route path is to account
#
describe 'Property#create', type: :feature do
  let(:account) { AccountPage.new }
  before(:each) { log_in }

  it 'opens valid page', js: true  do
    account.new
    expect(page.title).to eq 'Letting - New Account'
    expect(page).to have_css('.spec-entity-count', count: 1)
  end

  it '#create', js: true   do
    client_create human_ref: 8008
    charge = charge_create cycle: cycle_new(id: 1, charged_in: 'arrears')

    account.new
    fill_in_account property_ref: 278, client_ref: 8008, charge: charge
    fill_in_agent address: address_new
    account.button('Create').successful?(self).edit
    expect_account property_ref: '278', client_ref: 8008, charge: charge
    expect_agent
  end

  it '#creates an account without agent', js: true do
    client_create human_ref: 8008
    charge = charge_create cycle: cycle_new(id: 1, charged_in: 'advance')

    account.new
    fill_in_account property_ref: 278, client_ref: '8008', charge: charge
    account.button('Create').successful?(self).edit
    expect_account property_ref: '278', client_ref: 8008, charge: charge
  end

  it '#create has validation', js: true do
    client_create human_ref: 8008

    account.new
    account.property self, property_id: '-278', client_id: 8008
    account.button 'Create'
    expect(page.title).to eq 'Letting - New Account'
    expect(page).to have_text 'The property could not be saved.'
  end

  it 'adds charges', js: true do
    account.new
    expect(page).to have_css('.spec-charge-count', count: 1)
    3.times { click_on 'Add Charge' }
    expect(page).to have_css('.spec-charge-count', count: 4)
  end

  it 'displays form errors' do
    account.new
    account.button 'Create'
    expect(page).to have_css '[data-role="errors"]'
  end

  def fill_in_account(property_ref:, client_ref:, charge:)
    account.property self, property_id: property_ref, client_id: client_ref
    account.address selector: '#property_address', address: address_new
    account.entity(type: 'property', **person_attributes)
    account.charge charge: charge
  end

  def fill_in_agent(address:)
    check 'Agent'
    account.address selector: '#agent', address: address
    account.entity(type: 'property_agent_attributes', **company_attributes)
  end

  def expect_account property_ref:, client_ref:, charge: charge
    account.expect_property self,
                            property_id: property_ref,
                            client_id: client_ref
    account.expect_address self,
                           type: '#property_address',
                           address: address_new
    account.expect_entity self, type: 'property', **person_attributes
    account.expect_charge self, charge: charge
  end

  def expect_agent
    account.expect_address self,
                           type: '#property_agent_address',
                           address: address_new
    account.expect_entity self,
                          type: 'property_agent_attributes',
                          **company_attributes
  end
end
