####
#
# Arrears
#
# Returns a billing range given a billed_date
#
# A useless assignment which increases human reader's comprehension.
# rubocop: disable  Lint/UselessAssignment
####
#
class Arrears
  attr_reader :periods

  def initialize(repeat_dates:)
    @billed_dates_in_year = repeat_dates
    @periods = arrears_periods unless @billed_dates_in_year.empty?
  end

  def billing_period(billed_date:)
    found = @periods.find do |period|
      period.last == RepeatDate.new(date: billed_date)
    end
    return :missing_due_on unless found
    found.first.date..found.last.date
  end

  private

  # Arrears range pairs
  # Take two pairs of dates and make pairings
  #
  def arrears_periods(arrears_end: @billed_dates_in_year)
    arrears_start.zip arrears_end
  end

  # Creating the start pairs for arrears date periods.
  # @billed_dates_in_year: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  H +1D   E +1D   F +1D   G +1D -1Y
  def arrears_start
    arrears = @billed_dates_in_year.rotate(-1).map(&:tomorrow)
    arrears[0] = arrears[0].last_year
    arrears
  end
end
