####
#
# Advance
#
# Returns a period given a date within
#
# RangeCycle is the factory for billing range objects such as Advance and
# arrears.
#
# Initialize takes the repeated dates and calculates the period ranges from
# this - example 25th Mar and 30th Sep would result in two periods.
# 1) 25th Mar - 29th Sep
# 2) 30th Sep - 24th Mar of next year.
#
# As it stands: Ranges match on the date the bill becomes due. With advance
# this means the start, or first, date of a range - it then builds up the
# range and returns this to the caller.
#
# A useless assignment which increases human reader's comprehension.
# rubocop: disable  Lint/UselessAssignment
####
#
class Advance
  attr_reader :periods, :dates_in_year

  def initialize(repeat_dates:)
    @dates_in_year = repeat_dates
    periods unless dates_in_year.empty?
  end

  def duration(within:)
    found_period = periods.find do |period|
      period.first == RepeatDate.new(date: within)
    end
    return :missing_due_on unless found_period
    make_duration start: within, length: period_length(period: found_period)
  end

  # range pairs pairs dates to make periods
  #
  def periods(advance_start: dates_in_year)
    @periods = advance_start.zip(advance_end)
  end

  private

  def make_duration(start:, length:)
    range = start..start + length
    range = range.first..range.last + 1.day if Cover.leap_day? range: range
    range
  end

  def period_length(period:)
    (period.last.date - period.first.date).to_i
  end

  # Creating the end pairs for advance date ranges.
  # @dates_in_year: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  F -1D   G -1D   H -1D   E -1D +1Y
  def advance_end
    advance = Marshal.load(Marshal.dump(dates_in_year))
                     .rotate(1).map(&:yesterday)
    advance[-1] = advance[-1].next_year
    advance
  end
end
