def client_factory args = {}
  client = Client.new id: args[:id], human_client_id: args[:human_client_id]
  client.build_address address_attributes
  client.entities.build person_entity_attributes
  client.save!
  client
end