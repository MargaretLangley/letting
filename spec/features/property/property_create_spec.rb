require 'rails_helper'

describe Property, type: :feature do

  let(:account) { AccountPage.new }

  before(:each) do
    log_in
    client_create
  end

  it 'opens valid page', js: true  do
    account.new
    expect(page.title).to eq 'Letting - New Account'
    expect(page).to have_css('.spec-entity-count', count: 1)
  end

  it '#create', js: true   do
    charge_structure_create
    account.new
    fill_in_account
    fill_in_agent
    account.button('Create')
    account.successful?(self).edit
    expect_account
    expect_agent
  end

  it '#creates a account without agent', js: true do
    charge_structure_create
    account.new
    fill_in_account
    account.button('Create').successful?(self).edit
    expect_account
  end

  it '#create has validation', js: true do
    account.new
    account.property(self, property_id: '-278', client_id: '8008')
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

  def fill_in_account
    account.property(self, property_id: '278', client_id: '8008')
    account.address(selector: '#property_address',
                    **address_attributes.except(:district))
    account.entity(type: 'property', **person_attributes)
    account.charge(**(charge_attributes(charge_cycle: 'Mar/Sep',
                                        charged_in: 'Advance')
           .except(:account_id)))
  end

  def fill_in_agent
    check 'Agent'
    account.address(selector: '#agent',
                    **house_address_attributes.except(:district))
    account.entity(type: 'property_agent_attributes', **company_attributes)
  end

  def expect_account
    account.expect_property(self, property_id: '278', client_id: '8008')
    account.expect_address(self,
                           type: '#property_address',
                           **address_attributes.except(:district))
    account.expect_entity(self, type: 'property', **person_attributes)
    account.expect_charge(self,
                          **(charge_attributes(charged_in: 'Advance') \
                            .except(:account_id)))
  end

  def expect_agent
    account.expect_address(self,
                           type: '#property_agent_address',
                           **house_address_attributes.except(:district))
    account.expect_entity(self,
                          type: 'property_agent_attributes',
                          **company_attributes)
  end
end
