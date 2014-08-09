require 'spec_helper'

describe Property, type: :feature do

  let(:account) { AccountPage.new }

  before(:each) do
    log_in
    client_create!
    account.new
  end

  it 'opens valid page', js: true  do
    expect(page.title).to eq 'Letting - New Account'
    expect(page).to have_css('.spec-entity-count', count: 1)
  end

  it '#create', js: true  do
    skip 'charges being changed'
    fill_in_property
    fill_in_agent
    account.button('Create').successful?(self).edit
    expect_property
    expect_agent
  end

  it '#creates a account without agent', js: true do
    skip 'charges being changed'
    fill_in_property
    account.button('Create').successful?(self).edit
    expect_property
  end

  it '#create has validation', js: true do
    account.property(self, property_id: '-278', client_id: '8008')
    account.button 'Create'
    expect(page.title).to eq 'Letting - New Account'
    expect(page).to have_text 'The property could not be saved.'
  end

  it 'adds charges', js: true do
    expect(page).to have_css('.spec-charge-count', count: 1)
    3.times { click_on 'Add Charge' }
    expect(page).to have_css('.spec-charge-count', count: 4)
  end

  def fill_in_property
    account.property(self, property_id: '278', client_id: '8008')
    account.address(selector: '#property_address',
                    **address_attributes.except(:district))
    account.entity(type: 'property', **person_attributes)
    account.charge(**(charge_attributes.except(:account_id)))
    account.due_on
  end

  def fill_in_agent
    check 'Agent'
    account.address(selector: '#agent',
                    **house_address_attributes.except(:district))
    account.entity(type: 'property_agent_attributes', **company_attributes)
  end

  def expect_property
    account.expect_property(self, property_id: '278', client_id: '8008')
    account.expect_address(self,
                           type: '#property_address',
                           **address_attributes.except(:district))
    account.expect_entity(self, type: 'property', **person_attributes)
    account.expect_charge(self, **(charge_attributes.except(:account_id)))
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
