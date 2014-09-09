####
#
# LiteralSearch
#
# Responsible for exact match seraches for the application.
#
# Used by search Controller
#
# rubocop: disable  Style/MethodLength
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
    captured = default_ordered_query unless captured[:record_id] ||
                                            captured[:process_empty]
    captured
  end

  def type_query
    case @type
    when 'Client'
      {
        controller: 'clients',
        action: 'show',
        record_id: id_or_nil(Client.find_by human_ref: @query)
      }
    when 'Payment'
      {
        process_empty: process_empty(@query),
        controller: 'payments',
        action: 'new',
        record_id: id_or_nil(Account.find_by_human_ref @query)
      }
    when 'Property'
      {
        controller: 'properties',
        action: 'show',
        record_id: id_or_nil(Property.find_by human_ref: @query)
      }
    when 'User'
      {
        controller: 'users',
        action: 'show',
        record_id: id_or_nil(User.find_by nickname: @query)
      }
    when 'ChargeCycle'
      {
        controller: 'charge_cycles',
        action: 'show',
        record_id: id_or_nil(ChargeCycle.find_by name: @query)
      }
    else
      fail NotImplementedError, "Missing type: #{@type}"
    end
  end

  def id_or_nil record
    record ? record.id : nil
  end

  def process_empty query
    query.blank? ? 'true' : 'false'
  end

  def default_ordered_query
    record = Property.find_by(human_ref: @query) ||
      Client.find_by(human_ref: @query) ||
      User.find_by(nickname: @query) ||
      ChargeCycle.find_by(name: @query)
    { record_id: record }
  end
end
