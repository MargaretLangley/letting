require 'spec_helper'

describe 'Account Update', type: :feature do

  let(:account) { AccountPage.new }

  context 'Agentless' do
    before(:each) do
      log_in
      client = client_create
      property_create human_ref: 8000, client_id: client.id
    end

    it 'opens valid page', js: true  do
      account.edit
      expect(page.title).to eq 'Letting - Edit Account'
      account.expect_property(self, property_id: '8000', client_id: '8008')
      account.expect_address(self,
                             type: '#property_address',
                             **address_attributes)
      account.expect_entity(self, type: 'property', **person_attributes)
      # charge?
    end

    it 'updates account', js: true do
      account.edit
      account.property(self, property_id: '8001', client_id: '8008')
      account.address(selector: '#property_address', **house_address_attributes)
      account.entity(type: 'property', **company_attributes)
      account.button('Update').successful?(self).edit
      account.expect_property(self, property_id: '8001', client_id: '8008')
      account.expect_address(self,
                             type: '#property_address',
                             **house_address_attributes)
      account.expect_entity(self, type: 'property', **company_attributes)
    end

    it 'adds agent', js: true do
      account.edit
      check 'Agent'
      account.address(selector: '#agent', **nottingham_address)
      account.entity(type: 'property_agent_attributes', **company_attributes)

      account.button('Update').successful?(self).edit
      expect(find_field('Agent')).to be_checked
      account.expect_address(self,
                             type: '#property_agent_address',
                             **nottingham_address)
      account.expect_entity(self,
                            type: 'property_agent_attributes',
                            **company_attributes)
    end

    it 'navigates to accounts view page' do
      account.edit
      click_on 'View file'
      expect(page.title).to eq 'Letting - View Account'
    end

    it 'adds date charge' do
      charge_structure_create
      account.charge_initialization(charge_cycle: 'Mar/Sep',
                                    charged_in: 'Advance')
      account.edit
      account.charge(**(charge_attributes(charge_cycle: 'Mar/Sep',
                                          charged_in: 'Advance'
                                         ).except(:account_id)))
      account.button('Update').successful?(self).edit
      account.expect_charge(self,
                            **(charge_attributes(charged_in: 'Advance') \
                            .except(:account_id)))
    end
  end

  context 'Agentless with charge' do
    before(:each) do
      log_in
      client_create
    end

    it 'can be set to dormant', js: true do
      charge_structure_create
      property_with_charge_create human_ref: 8000
      account.edit
      expect(page).to have_css('.spec-charge-count', count: 1)
      dormant_checkbox =
      '//*[@id="property_account_attributes_charges_attributes_0_dormant"]'
      find(:xpath, dormant_checkbox).set(true)
      account.button('Update').successful?(self).edit
      expect(find(:xpath, dormant_checkbox)).to be_checked
    end
  end

  context 'with Agent' do
    before(:each) do
      log_in
      client = client_create
      property_with_agent_create human_ref: 8000, client_id: client.id
      account.edit
    end

    it 'opens property with agent', js: true  do
      expect(find_field('Agent')).to be_checked
      account.expect_address(self,
                             type: '#property_agent_address',
                             **oval_address_attributes)
      account.expect_entity(self,
                            type: 'property_agent_attributes',
                            **oval_person_entity_attributes)
    end

    it 'updates agent' do
      account.address(selector: '#agent', **nottingham_address)
      account.entity(type: 'property_agent_attributes', **company_attributes)

      account.button('Update').successful?(self).edit
      account.expect_address(self,
                             type: '#property_agent_address',
                             **nottingham_address)
      account.expect_entity(self,
                            type: 'property_agent_attributes',
                            **company_attributes)
    end

    it 'removes agent' do
      uncheck 'Agent'
      account.button('Update').successful?(self).edit
      expect(find_field('Agent')).to_not be_checked
    end
  end
end
