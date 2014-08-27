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
    charge_cycle_create(id: 1, name: 'Mar/Sep')
    charged_in_create(id: 1, name: 'Arrears')
    cycle_charged_in_create id: 1, charge_cycle_id: 1, charged_in_id: 1
    account.new
    fill_in_account property_ref: 278,
                    client_ref: '8008',
                    charge_cycle_id: 1,
                    charged_in_id: 1
    fill_in_agent
    account.button('Create').successful?(self).edit
    expect_account property_ref: '278', client_ref: '8008', charged_in_id: 1
    expect_agent
  end

  it '#creates a account without agent', js: true do
    charge_cycle_create(id: 1, name: 'Mar/Sep')
    charged_in_create(id: 2, name: 'Advance')
    cycle_charged_in_create id: 1, charge_cycle_id: 1, charged_in_id: 2
    account.new
    fill_in_account property_ref: 278,
                    client_ref: '8008',
                    charge_cycle_id: 1,
                    charged_in_id: 2
    account.button('Create').successful?(self).edit
    expect_account property_ref: '278', client_ref: '8008', charged_in_id: 2
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

  def fill_in_account(property_ref:,
                      client_ref:,
                      charge_cycle_id:,
                      charged_in_id:)
    account.property(self, property_id: property_ref, client_id: client_ref)
    account.address(selector: '#property_address',
                    **address_attributes.except(:district))
    account.entity(type: 'property', **person_attributes)
    account.charge(**(charge_attributes(charge_cycle_id: charge_cycle_id,
                                        charged_in_id: charged_in_id)
           .except(:account_id)))
  end

  def fill_in_agent
    check 'Agent'
    account.address(selector: '#agent',
                    **house_address_attributes.except(:district))
    account.entity(type: 'property_agent_attributes', **company_attributes)
  end

  def expect_account(property_ref:, client_ref:, charged_in_id:)
    account.expect_property self,
                            property_id: property_ref,
                            client_id: client_ref
    account.expect_address(self,
                           type: '#property_address',
                           **address_attributes.except(:district))
    account.expect_entity(self, type: 'property', **person_attributes)
    account.expect_charge(self,
                          **(charge_attributes(charged_in_id: charged_in_id) \
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
