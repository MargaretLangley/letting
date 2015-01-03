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

  def years
    (Time.zone.now.year.downto(Time.zone.now.year - 4)).map(&:to_s)
  end

  def mar_sep
    client.properties.houses.quarter_day_in(3).map(&:account)
  end

  def jun_dec
    client.properties.houses.quarter_day_in(6).map(&:account)
  end

  def mar_range
    time = Time.zone.local(year, 3, 1)
    time..(time + 6.months)
  end

  def sep_range
    time = Time.zone.local(year, 9, 1)
    time..(time + 6.months)
  end

  def jun_range
    time = Time.zone.local(year, 6, 1)
    time..(time + 6.months)
  end

  def dec_range
    time = Time.zone.local(year, 12, 1)
    time..(time + 6.months)
  end
end
