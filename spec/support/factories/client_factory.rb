def client_new args = {}
  base_client args
end

def client_create! args = {}
  client = base_client args
  client.save!
  client
end

def client_two_entities_create! args = {}
  client = base_client args
  client.entities.build oval_person_entity_attributes
  client.save!
  client
end

def client_company_create! args = {}
  client = Client.new client_attributes args
  client.build_address address_attributes args.fetch(:address_attributes, {})
  client.entities.build company_entity_attributes
  client.save!
  client
end

private

def base_client args = {}
  client = Client.new client_attributes args
  client.build_address address_attributes args.fetch(:address_attributes, {})
  client.entities.build person_entity_attributes
  client
end


