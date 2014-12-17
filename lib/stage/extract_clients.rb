require_relative 'extract'
######
#
# ExtractClient
#
# Removes client, array elements, from an array.
#
class ExtractClients < Extract
  def match original, extract
    original[:human_ref] == extract[:human_ref]
  end
end
