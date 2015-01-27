####
#
# LiteralSearch
#
# Responsible for exact match searches for the application.
#
# Used by search Controller
#
# rubocop: disable  Metrics/MethodLength
# TODO: remove CyclomaticComplexity
# rubocop: disable Metrics/CyclomaticComplexity
#
####
#
class LiteralSearch
  attr_reader :type, :query
  def self.search(type:, query:)
    new(type: type, query: query)
  end

  def initialize(type:, query:)
    @type = type
    @query = query
  end

  def go
    captured = type_query
    captured = default_ordered_query unless captured.found?
    captured
  end

  def type_query
    case type
    when 'Cycle' then cycle(query)
    when 'Client' then client(query)
    when 'Payment' then payment(query)
    when 'Property' then property(query)
    when 'User' then user(query)
    else
      fail NotImplementedError, "Missing type: #{type}"
    end
  end

  private

  def client query
    LiteralResult.new action: 'show',
                      controller: 'clients',
                      id: id_or_nil(Client.find_by human_ref: query)
  end

  def cycle query
    LiteralResult.new action: 'show',
                      controller: 'cycles',
                      id: id_or_nil(Cycle.find_by name: query)
  end

  def payment query
    LiteralResult.new action: 'new',
                      controller: 'payments',
                      id: id_or_nil(Account.find_by_human_ref query),
                      empty: query.blank? ? 'true' : 'false'
  end

  def property query
    LiteralResult.new action: 'show',
                      controller: 'properties',
                      id: id_or_nil(Property.find_by human_ref: query)
  end

  def user query
    LiteralResult.new action: 'show',
                      controller: 'users',
                      id: id_or_nil(User.find_by nickname: query)
  end

  def id_or_nil record
    record ? record.id : nil
  end

  def default_ordered_query
    return property(query) if property(query).found?
    return client(query) if client(query).found?

    LiteralResult.missing
  end
end
