def add_contact contact_me, args = {}
  add_address contact_me, args
  add_entity contact_me, args
end

def add_entity entity_me, args = {}
  unless args[:entities_attributes]
    entity_me.entities.build person_entity_attributes
  else
    entity_me.entities.build person_entity_attributes args[:entities_attributes]
  end
end

def add_address address_me, args = {}
  unless args[:address_attributes]
    address_me.build_address address_attributes
  else
    address_me.build_address address_attributes args[:address_attributes]
  end
end
