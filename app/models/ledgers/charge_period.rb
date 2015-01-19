#
# TODO: are we using ChargePeriod 19/01/2015 - cannot find reference
#
class ChargePeriod
  attr_reader :first, :last

  def initialize(year:, first:, last:)
    @first = Time.zone.local(year, first, 1, 00, 00)
    @last = Time.zone.local(year, last, 1, 00, 00)
  end

  def first_month
    Date::ABBR_MONTHNAMES[first.month]
  end

  def last_month
    Date::ABBR_MONTHNAMES[last.month]
  end

  def first_month_no
    first.month
  end

  def last_month_no
    last_month_no.month
  end

  def first_period
    first..period_length(first)
  end

  def last_period
    last..period_length(last)
  end

  private

  def period_length period
    period + 6.months
  end
end
