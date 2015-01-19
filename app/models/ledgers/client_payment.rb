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
# rubocop: disable  Metrics/LineLength
#
class ClientPayment
  MAR_SEP = [3, 9]
  JUN_DEC = [6, 12]
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

  def quarter_day_accounts(charge_months:)
    Account.joins(:property)
      .merge(client.properties.houses.quarter_day_in(charge_months.first))
      .order('properties.human_ref ASC')
  end

  # 6 months periods
  # month - starting month
  #
  def total_period(month:)
    time = Time.zone.local(year, month, 1)
    time..(time + 6.months)
  end

  def total(period:)
    Payment.where(booked_at: period.first...period.last)
      .where(account_id: quarter_day_accounts(charge_months: period.first.month..
                                                             period.last.month)
        .pluck(:account_id))
      .pluck(:amount).sum
  end
end
