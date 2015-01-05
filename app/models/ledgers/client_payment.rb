# ClientPayment
#
# Returns the payments made to a client for house ground rent.
#
# Clients have a number of properties that ground rent are charged on.
# When a tenant pays money for this charge the client gets this money
# minus handling fees.
#
# Houses are either divided into Mar/Sep and Jun/Dec. So, for each house
# payments are broken into 6 month periods starting either Mar and Sep or
# Jun and Dec - periods are always started on the 1st day of the month.
#
class ClientPayment
  MAR = 3
  JUN = 6
  SEP = 9
  DEC = 12
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
    quarter_day_accounts(month: MAR)
  end

  def jun_dec
    quarter_day_accounts(month: JUN)
  end

  def half_year_from(month:)
    time = Time.zone.local(year, month, 1)
    time..(time + 6.months)
  end

  def half_year_total(month:)
    range = half_year_from(month: month)
    Payment.where(booked_on: range.first...range.last)
      .where(account_id: quarter_day_accounts(month: month).pluck(:account_id))
      .pluck(:amount).sum * -1
  end

  private

  def quarter_day_accounts(month:)
    Account.joins(:property)
      .merge(client.properties.houses.quarter_day_in(month))
      .order('properties.human_ref ASC')
  end
end
