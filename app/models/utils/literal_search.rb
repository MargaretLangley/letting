####
#
# LiteralSearch
#
# Responsible for exact match searches for the application.
#
# Used by search Controller
#
####
#
class LiteralSearch
  attr_reader :referrer, :query

  # referrer: the model and action of the query being executed - one of Client,
  #           Payment, Property, Arrear or Invoice and any of the actions.
  # query: the search terms being queried on the model
  #
  def self.search(referrer:, query:)
    new(referrer: referrer, query: query)
  end

  # go
  # Executes the query
  # returns LiteralResult - a wrapper for the search results
  #
  def go
    captured = query_by_referrer
    captured = default_ordered_query unless captured.concluded?
    captured
  end

  private

  def initialize(referrer:, query:)
    @referrer = referrer
    @query = query
  end

  def query_by_referrer
    case referrer.controller
    when 'clients' then client(query)
    when 'payments' then payment(query)
    when 'properties' then property(query)
    when 'arrears', 'cycles', 'users', 'invoice_texts', 'invoicings', 'invoices'
      LiteralResult.without_a_search
    else
      fail NotImplementedError, "Missing: #{referrer}"
    end
  end

  def client query
    LiteralResult.new action: 'show',
                      controller: 'clients',
                      id: id_or_nil(Client.find_by_human_ref query)
  end

  def payment query
    LiteralResult.new action: 'new',
                      controller: 'payments',
                      id: id_or_nil(Account.find_by_human_ref query),
                      completes: true
  end

  def property query
    LiteralResult.new action: 'show',
                      controller: 'properties',
                      id: id_or_nil(Property.find_by_human_ref query)
  end

  def id_or_nil record
    record ? record.id : nil
  end

  def default_ordered_query
    return property(query) if property(query).concluded?
    return client(query) if client(query).concluded?

    LiteralResult.no_record_found
  end
end
