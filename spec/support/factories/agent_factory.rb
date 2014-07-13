def agent_new args = {}
  base_agent args
end

def nameless_agent args = {}
  agent = Agent.new agent_attributes args
  agent.build_address address_attributes args.fetch(:address_attributes, {})
  agent
end

private

def base_agent args = {}
  agent = Agent.new agent_attributes args
  agent.build_address address_attributes args.fetch(:address_attributes, {})
  agent.entities.build person_entity_attributes
  agent
end
