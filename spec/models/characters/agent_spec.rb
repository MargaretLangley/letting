require 'rails_helper'

describe Agent, type: :model do

  it('is valid') { expect(agent_new).to be_valid }

  # describe 'methods' do
  #   it 'returns #full_name' do
  #     agent = agent_new entities: [Entity.new(title: 'Mr', name: 'Bell')]
  #     expect(agent.full_name).to eq 'Mr Bell'
  #   end

  #   it 'returns #address_text' do
  #     agent = agent_new address: address_new(road: 'High')
  #     expect(agent.address_text).to eq "High\nBirmingham\nWest Midlands"
  #   end

  #   it 'returns #to_s' do
  #     agent = agent_new entities: [Entity.new(title: 'Mr', name: 'Bell')],
  #                       address: address_new(road: 'High')
  #     expect(agent.to_s).to eq "Mr Bell\nHigh\nBirmingham\nWest Midlands"
  #   end
  # end

  context 'when authorized' do
    it 'clear_up only removes dummy entity' do
      (agent = agent_new).authorized = true
      agent.clear_up_form
      expect(saveable_entities(agent.entities)).to eq(1)
    end
  end

  context 'when unauthorized' do
    describe 'clear_up form' do
      it 'removes all entities' do
        (agent = agent_new).authorized = false
        agent.clear_up_form
        expect(saveable_entities(agent.entities)).to eq(0)
      end

      it 'remains valid' do
        (agent = agent_new).authorized = false
        agent.clear_up_form
        expect(agent).to be_valid
      end
    end
  end

  def saveable_entities entities
    entities.reject(&:marked_for_destruction?).size
  end
end
