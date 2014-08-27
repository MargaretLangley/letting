def property_new account: nil, agent: nil, client: nil, prepare: false, **args
  property = base_property prepare, args
  add_no_agent property
  property.account = account if account
  property.agent = agent if agent
  property.client = client if client
  property
end

def property_create(account: nil, agent: nil, client: nil, **args)
  (property = property_new(account: account, agent: agent, client: client, **args)).save!
  property
end

def property_with_agent_create **args
  property = base_property args
  add_agent property
  property.save!
  property
end

def property_with_charge_create **args
  (property = property_with_charge_new args).save!
  property
end

# when your running full specs I haven't found reliable way of guaranteeing
# a primary key will be set to a value. This is a hack to save the object
# get the key value and put it into the debit - not nice
def property_with_charge_and_unpaid_debit
  (property = property_with_charge_new).save!
  property.account.debits.build debit_attributes \
    charge_id: property.account.charges.first.id
  property
end

private

def property_with_charge_new charge: nil, **args
  property = base_property args
  add_no_agent property
  if charge
    property.account.charges << charge
  else
    add_charge property
  end
  property
end

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

def add_charge charge_me
  charge_me.account.charges.build charge_attributes
end
