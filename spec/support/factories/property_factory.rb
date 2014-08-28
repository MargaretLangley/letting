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
