def client_factory args = {}
  client = Client.new id: args[:id], human_id: args[:human_id]
  add_address client
  add_entity client
  client.save!
  client
end