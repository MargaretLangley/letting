require 'rails_helper'

describe 'Agent Factory' do
  describe 'default' do
    it('is valid') { expect(agent_new).to be_valid }
    it('has name') { expect(agent_new.full_name).to eq 'Mr W. G. Grace'}
    it('has road') { expect(agent_new.address.road).to eq 'Edgbaston Road'}
  end

  describe 'overrides' do
    it 'changes name' do
      agent = agent_new entities: [Entity.new(name: 'Bell') ]
      expect(agent.entities.first.name).to eq 'Bell'
    end

    it 'changes address' do
      agent = agent_new address: address_new(road: 'Wiggiton')
      expect(agent.address.road).to eq 'Wiggiton'
    end
  end
end
