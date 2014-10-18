####
#
# Arrears
#
# Returns a period given a date within
#
# See Advance for more information.
#
# A useless assignment which increases human reader's comprehension.
# rubocop: disable  Lint/UselessAssignment
####
#
class Arrears
  attr_reader :periods, :dates_in_year

  def initialize(repeat_dates:)
    @dates_in_year = repeat_dates
    periods unless dates_in_year.empty?
  end

  def duration(within:)
    found_period = periods.find do |period|
      period.last == RepeatDate.new(date: within)
    end
    return :missing_due_on unless found_period
    make_duration finish: within, length: period_length(period: found_period)
  end

  # range pairs pairs dates to make periods
  #
  def periods(arrears_end: dates_in_year)
    @periods = arrears_start.zip arrears_end
  end

  private

  def make_duration(finish:, length:)
    range = finish - length..finish
    range = range.first..range.last + 1.day if Cover.leap_day? range: range
    range
  end

  def period_length(period:)
    (period.last.date - period.first.date).to_i
  end

  # Creating the start pairs for arrears date periods.
  # @dates_in_year: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  H +1D   E +1D   F +1D   G +1D -1Y
  def arrears_start
    arrears = Marshal.load(Marshal.dump(dates_in_year))
                     .rotate(-1).map(&:tomorrow)
    arrears[0] = arrears[0].last_year
    arrears
  end
end
