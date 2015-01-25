require 'rails_helper'

describe 'Account Update', type: :feature  do
  let(:account) { AccountPage.new }

  context 'Agentless' do
    before(:each) do
      log_in
      client_create \
        human_ref: 90,
        properties: [property_new(human_ref: 80, account: account_new)]
    end

    it 'opens valid page', js: true  do
      account.edit
      expect(page.title).to eq 'Letting - Edit Account'
      account.expect_property self, property_id: '80', client_id: '90'
      account.expect_address self,
                             type: '#property_address',
                             address: address_new
      account.expect_entity self, type: 'property', **person_attributes
      # charge?
    end

    it 'updates account', js: true do
      account.edit
      account.property self, property_id: '81', client_id: '90'
      account.address selector: '#property_address', address: address_new
      account.entity type: 'property', **company_attributes
      account.button('Update').successful?(self).edit
      account.expect_property self, property_id: '81', client_id: '90'
      account.expect_address self,
                             type: '#property_address',
                             address: address_new
      account.expect_entity self, type: 'property', **company_attributes
    end

    it 'adds agent', js: true do
      account.edit
      check 'Agent'
      account.address selector: '#agent', address: address_new
      account.entity type: 'property_agent_attributes', **company_attributes

      account.button('Update').successful?(self).edit
      expect(find_field('Agent')).to be_checked
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new
      account.expect_entity self,
                            type: 'property_agent_attributes',
                            **company_attributes
    end

    it 'navigates to accounts view page' do
      account.edit
      click_on 'View file'
      expect(page.title).to eq 'Letting - View Account'
    end

    it 'adds date charge' do
      charged_in = charged_in_create id: 2, name: 'Advance'
      charge = charge_create cycle: cycle_new(id: 1, charged_in: charged_in),
                             payment_type: 'payment'
      account.edit
      account.charge charge: charge
      account.button('Update').successful?(self).edit
      account.expect_charge self, charge: charge
    end

    it 'deletes charge' do
      skip 'While the charge is deleted the test does not pass'
      charged_in = charged_in_create id: 2, name: 'Advance'
      charge = charge_create cycle: cycle_new(id: 1, charged_in: charged_in)
      Account.first.charges << charge
      account.edit
      expect(Account.first.charges.size).to eq 1
      account.charge order: 0, delete: true
      account.button('Update').successful?(self).edit
      expect(Account.first.charges.size).to eq 0
    end

    it 'displays form errors' do
      account.edit
      account.address selector: '#property_address',
                      address: address_new(road: '')
      account.button 'Update'
      expect(page).to have_css '[data-role="errors"]'
    end
  end

  context 'Agentless with charge' do
    before(:each) do
      log_in
      client_create
    end

    it 'can be set to dormant', js: true do
      property_create account:
                        account_new(charges: [charge_new(activity: 'active')])
      account.edit
      activity =
        '//*[@id="property_account_attributes_charges_attributes_0_activity"]'
      expect(find(:xpath, activity).value).to eq 'active'

      find(:xpath, activity).select 'dormant'

      account.button('Update').successful?(self).edit
      expect(find(:xpath, activity).value).to eq 'dormant'
    end
  end

  context 'with Agent' do
    before(:each) do
      log_in
      agent = agent_new entities: [Entity.new(name: 'Willis')],
                        address: address_new(road: 'Wiggiton')
      client_create properties: property_new(account: account_new, agent: agent)
      account.edit
    end

    it 'opens property with agent', js: true  do
      expect(find_field('Agent')).to be_checked
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new(road: 'Wiggiton')
      account.expect_entity(self,
                            type: 'property_agent_attributes',
                            name: 'Willis')
    end

    it 'updates agent' do
      account.address(selector: '#agent', address: address_new)
      account.entity(type: 'property_agent_attributes', **company_attributes)

      account.button('Update').successful?(self).edit
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new
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
