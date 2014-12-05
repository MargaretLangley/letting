# rubocop: disable Metrics/MethodLength

def client_new(
  id: nil,
  human_ref: 354,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')],
  property: nil)
  client = Client.new id: id,
                      human_ref: human_ref,
                      address: address,
                      entities: entities
  client.properties << property if property
  client
end

def client_create(
  id: nil,
  human_ref: 354,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')],
  property: nil)
  client = client_new id: id,
                      human_ref: human_ref,
                      address: address,
                      entities: entities,
                      property: property
  client.save!
  client
end
