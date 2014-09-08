####
#
# FullTextSearch
#
# Returns the full-text search results for a query
#
# Interface between the full-text-search app (elasticsearch)
# and the application. Calls search methods which are generated
# by the elasticsearch gem and the searchable moddule.
#
# rubocop: disable Style/MethodLength
#
####
#
class FullTextSearch
  def self.search(type:, query:)
    new(type: type, query: query)
  end

  def initialize(type:, query:)
    @type = type
    @query = query
  end

  def go
    captured = results
    captured = default if captured[:records].count.zero?
    captured
  end

  def default
    { success: false, records: Property.all, render: 'properties/index' }
  end

  # Instantiate class from name string
  # Object.const_get(@type).search(@query)
  def results
    case @type
    when 'clients'
      {
        success: true,
        records: Client.search(@query).records,
        render: 'clients/index'
      }
    else
      {
        success: true,
        records: Property.search(@query).records,
        render: 'properties/index'
      }
    end
  end
end
