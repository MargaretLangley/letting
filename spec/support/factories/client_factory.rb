def client_factory args = {}
  client = Client.new id: args[:id], human_id: args[:human_id]
  add_address client, args
  add_entity client, args
  client.save!
  client
end