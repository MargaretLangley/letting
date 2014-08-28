def property_new account: nil,
                 agent: nil,
                 client: nil,
                 prepare: false,
                 **args
  property = base_property prepare, args
  add_no_agent property
  property.account = account if account
  property.agent = agent if agent
  property.client = client if client
  property
end

def property_create account: nil,
                    agent: nil,
                    client: nil,
                    **args
  (property = property_new(account: account,
                           agent: agent,
                           client: client,
                           **args)).save!
  property
end

def property_with_agent_create **args
  property = base_property args
  add_agent property
  property.save!
  property
end

private

def base_property  prepare, **args
  property = Property.new property_attributes args
  property.prepare_for_form if prepare
  property.build_address address_attributes args.fetch(:address_attributes, {})
  property.entities.build person_entity_attributes
  property
end

def add_no_agent bill_me
  bill_me.build_agent authorized: false
end

def add_agent bill_me
  bill_me.build_agent authorized: true
  bill_me.agent.build_address oval_address_attributes
  bill_me.agent.entities.build oval_person_entity_attributes
end
