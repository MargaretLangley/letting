def client_new human_ref: 354,
               address: address_new,
               entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')]
  Client.new human_ref: human_ref, address: address, entities: entities
end

def client_create(
  human_ref: 354,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')])
  client = Client.new human_ref: human_ref, address: address, entities: entities
  client.save!
  client
end
