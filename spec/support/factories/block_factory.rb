def block_factory args = {}
  block = Block.new id: args[:id], name: args[:name], client_id: args[:client_id]
  block.save!
  block
end