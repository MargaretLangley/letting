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
  attr_reader :client_id, :year, :month
  def initialize(client_id:)
    @client_id = client_id
  end

  def self.query(client_id: 1)
    new(client_id: client_id)
  end

  # the client object of used to initialize
  #
  def client
    @client ||= Client.find client_id
  end

  def details(year:, month:)
    @year = year
    @month = month
  end

  # Arbitrary range of years of payments to cover
  #
  def years
    (Time.zone.now.year.downto(Time.zone.now.year - 4)).map(&:to_s)
  end

  # Accounts grouped by charge_months:
  # charge_months has two main groups: Mar/Sep and Jun/Dec
  # Mar/Sep which has sub-groups (Mar and Sep)
  # Jun/Dec which has sub-groups (Jun and Dec)
  # Argument: charge_months: MAR_SEP = [3, 9] or JUN_DEC = [6, 12]
  #
  def quarter_day_accounts(charge_months:)
    Account.joins(:property)
      .merge(client.properties.houses.quarter_day_in(charge_months.first))
      .order('properties.human_ref ASC')
  end

  # Client account payments for one of the charge_month periods.
  #
  def period_total(year:, month:)
    period = total_period(year: year, month: month)
    Payment.where(booked_at: period.first...period.last)
      .where(account_id: quarter_day_accounts(charge_months: period.first.month..
                                                             period.last.month)
        .pluck(:account_id))
      .pluck(:amount).sum
  end

  # client payments for one account for a year and month
  #
  def account_period_total(account:, year:, month:)
    period = total_period(year: year, month: month)
    Payment.where(booked_at: period.first...period.last)
      .where(account_id: account.id).pluck(:amount).sum
  end

  def detailed_period_total
    period_total year: year, month: month
  end

  def detailed_account_period_total(account:)
    account_period_total account: account, year: year, month: month
  end

  private

  # Calculates the 6 months periods for input into total method
  # Arguments:
  # year  - starting year
  # month - starting month
  #
  def total_period(year:, month:)
    time = Time.zone.local(year, month, 1)
    time..(time + 6.months)
  end
end
