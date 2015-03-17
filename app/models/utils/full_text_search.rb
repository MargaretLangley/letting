####
#
# FullTextSearch
#
# Returns the full-text search results for a query
#
# Interface between the full-text-search application (Elasticsearch)
# and the application. Calls search methods which are generated
# by the Elasticsearch gem and the searchable module.
#
# rubocop: disable Metrics/MethodLength
#
####
#
class FullTextSearch
  attr_reader :query, :type
  def self.search(type:, query:)
    new(type: type, query: query)
  end

  def initialize(type:, query:)
    @type = type
    @query = query
  end

  def go
    results
  end

  # Instantiate class from name string
  # Object.const_get(type).search(query)
  def results
    case type
    when 'Client'
      records = Client.search(query, sort: 'human_ref').records
      { records: records, render: 'clients/index' }
    when 'Payment'
      records = Payment.search(query, sort: 'booked_at').records
      { records: records, render: 'payments/index' }
    else
      records = Property.search(query, sort: 'human_ref').records
      { records: records, render: 'properties/index' }
    end
  end
end
