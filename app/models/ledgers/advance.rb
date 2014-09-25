####
#
# Advance
#
# Returns a billing range given a billed_date
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
    found.first.date..found.last.date
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
    advance = @billed_dates_in_year.rotate(1).map(&:yesterday)
    advance[-1] = advance[-1].next_year
    advance
  end
end
