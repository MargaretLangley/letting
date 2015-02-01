require 'rails_helper'

#
# Property's route path is to account
#
describe 'Property#Update', type: :feature  do
  let(:account) { AccountPage.new }

  context 'Agentless' do
    before(:each) do
      log_in
      client_create \
        human_ref: 90,
        properties: [property_new(id: 1, human_ref: 80, account: account_new)]
    end

    it 'opens valid page', js: true  do
      account.load id: 1
      expect(account.title).to eq 'Letting - Edit Account'
      account.expect_property self, property_id: '80', client_id: '90'
      account.expect_address self,
                             type: '#property_address',
                             address: address_new
      account.expect_entity self, type: 'property', **person_attributes
      # charge?
    end

    it 'updates account', js: true do
      account.load id: 1
      account.property self, property_id: '81', client_id: '90'
      account.address selector: '#property_address', address: address_new
      account.entity type: 'property', **company_attributes
      account.button('Update').successful?(self).load id: 1
      account.expect_property self, property_id: '81', client_id: '90'
      account.expect_address self,
                             type: '#property_address',
                             address: address_new
      account.expect_entity self, type: 'property', **company_attributes
    end

    it 'adds agent', js: true do
      account.load id: 1
      check 'Agent'
      account.address selector: '#agent', address: address_new
      account.entity type: 'property_agent_attributes', **company_attributes

      account.button('Update').successful?(self).load id: 1
      expect(find_field('Agent')).to be_checked
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new
      account.expect_entity self,
                            type: 'property_agent_attributes',
                            **company_attributes
    end

    it 'adds date charge' do
      charge = charge_create cycle: cycle_new(id: 1, charged_in: 'advance'),
                             payment_type: 'manual'
      account.load id: 1

      account.charge charge: charge
      account.button('Update').successful?(self).load id: 1
      account.expect_charge self, charge: charge
    end

    it 'deletes charge', js: true do
      charge = charge_create cycle: cycle_new(id: 1, charged_in: 'advance')
      Account.first.charges << charge
      account.load id: 1
      expect(Account.first.charges.size).to eq 1

      account.delete_charge

      account.button('Update').successful?(self)

      expect(Account.first.charges.size).to eq 0
    end

    it 'displays form errors' do
      account.load id: 1

      account.address selector: '#property_address',
                      address: address_new(road: '')
      account.button 'Update'
      expect(page).to have_css '[data-role="errors"]'
    end
  end

  context 'Agentless with charge' do
    before { log_in }

    it 'can be set to dormant', js: true do
      property_create \
        id: 1, account: account_new(charges: [charge_new(activity: 'active')])
      account.load id: 1
      activity =
        '//*[@id="property_account_attributes_charges_attributes_0_activity"]'
      expect(find(:xpath, activity).value).to eq 'active'

      find(:xpath, activity).select 'dormant'

      account.button('Update').successful?(self).load id: 1
      expect(find(:xpath, activity).value).to eq 'dormant'
    end
  end

  context 'with Agent' do
    before(:each) do
      log_in
      agent = agent_new entities: [Entity.new(name: 'Willis')],
                        address: address_new(road: 'Wiggiton')

      property_create id: 1, account: account_new, agent: agent
      account.load id: 1
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

      account.button('Update').successful?(self).load id: 1
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new
      account.expect_entity(self,
                            type: 'property_agent_attributes',
                            **company_attributes)
    end

    it 'removes agent' do
      uncheck 'Agent'
      account.button('Update').successful?(self).load id: 1
      expect(find_field('Agent')).to_not be_checked
    end
  end
end
