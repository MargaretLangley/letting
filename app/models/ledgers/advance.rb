####
#
# Advance
#
# Returns a billing range given a billed_date
#
# RangeCycle is the factory for billing range objects such as Advance and
# arrears.
#
# Initialize takes the repeated dates and calculates the range of a bill from
# this - example 25th Mar and 30th Sep would result in two periods.
# 1) 25th Mar - 29th Sep
# 2) 30th Sep - 24th Mar of next year.
#
# Ranges match on the date the bill becomes due. With advance this
# means the start, or first, date of a range - it then builds up the range and
# returns this to the caller.
#
# A useless assignment which increases human reader's comprehension.
# rubocop: disable  Lint/UselessAssignment
####
#
class Advance
  attr_reader :periods

  def initialize(repeat_dates:)
    @billed_dates_in_year = repeat_dates
    @periods = advance_periods unless @billed_dates_in_year.empty?
  end

  def billing_period(billed_date:)
    found = @periods.find do |period|
      period.first == RepeatDate.new(date: billed_date)
    end
    return :missing_due_on unless found
    billed_date..billed_date + period_length(period: found)
  end

  def period_length(period:)
    period.last.date - period.first.date
  end

  def dates
    @periods.map { |period| [period.first.date, period.last.date] }
  end

  private

  # Advance range pairs
  # Take two pairs of dates and make pairings
  #
  def advance_periods(advance_start: @billed_dates_in_year)
    advance_start.zip(advance_end)
  end

  # Creating the end pairs for advance date ranges.
  # @billed_dates_in_year: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  F -1D   G -1D   H -1D   E -1D +1Y
  def advance_end
    advance = Marshal.load(Marshal.dump(@billed_dates_in_year))
                     .rotate(1).map(&:yesterday)
    advance[-1] = advance[-1].next_year
    advance
  end
end
