# ClientPayment
#
# Returns the payments
#
# To execute sql on postgres use the command line:
# -- psql -d letting_development -f show.sql
#
class ClientPayment
  attr_reader :client_id, :year

  def initialize(client_id:, year:)
    @client_id = client_id
    @year = year
  end

  def self.query(client_id: 1, year:)
    new(client_id: client_id, year: year)
  end

  def client
    Client.find client_id
  end

  def mar_sep
    client.properties.houses.quarter_day_in(3).map(&:account)
  end

  def jun_dec
    client.properties.houses.quarter_day_in(6).map(&:account)
  end
end
