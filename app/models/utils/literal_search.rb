####
#
# LiteralSearch
#
# Responsible for exact match seraches for the application.
#
# Used by search Controller
#
####
#
class LiteralSearch
  def self.search(type:, query:)
    new(type: type, query: query)
  end

  def initialize(type:, query:)
    @type = type
    @query = query
  end

  def go
    captured = type_query
    captured = default_ordered_query unless captured
    captured
  end

  def type_query
    case @type
    when 'Client'      then Client.find_by human_ref: @query
    when 'Property'    then Property.find_by human_ref: @query
    when 'User'        then User.find_by nickname: @query
    when 'ChargeCycle' then ChargeCycle.find_by(name: @query)
    else
      fail NotImplementedError, "Missing type: #{@type}"
    end
  end

  def default_ordered_query
    Property.find_by(human_ref: @query) ||
      Client.find_by(human_ref: @query) ||
      User.find_by(nickname: @query) ||
      ChargeCycle.find_by(name: @query)
  end
end
