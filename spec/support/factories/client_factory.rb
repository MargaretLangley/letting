def client_new(
  human_ref: 354,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')],
  property: nil)
  client = Client.new human_ref: human_ref, address: address, entities: entities
  client.properties << property if property
  client
end

def client_create(
  human_ref: 354,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')],
  property: nil)
  client = Client.new human_ref: human_ref, address: address, entities: entities
  client.properties << property if property
  client.save!
  client
end
