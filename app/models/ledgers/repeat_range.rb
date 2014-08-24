class RepeatRange
  include Comparable
  include Enumerable
  attr_reader :dates_in_year

  def initialize(dates: dates, repeat_dates: repeat_dates)
    @dates_in_year = []
    @dates_in_year = dates.map { |date| RepeatDate.new date: date } if dates
    @dates_in_year = repeat_dates if repeat_dates
  end

  def push(repeat_date:)
    @dates_in_year.push repeat_date
  end

  # Advance range pairs
  # Take two pairs of @dates with year and arrange them to make the pairings
  # into advance ranges.
  #
  def advance_ranges
    advance_start = @dates_in_year
    advance_start.zip(advance_end)
  end

  # Arrears range pairs
  # Take two pairs of @dates with year and arrange them to make the pairings
  # into arrears ranges.
  #
  def arrears_ranges
    arrears_end = @dates_in_year
    arrears_start.zip(arrears_end)
  end

  def find identify
    @dates_in_year.find { |repeat_date| repeat_date.date == identify }
  end

  private

  # Creating the start pairs for arrears date ranges.
  # @dates_in_year: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  H +1D   E +1D   F +1D   G +1D -1Y
  def arrears_start
    arrears = @dates_in_year.rotate(-1).map do |date|
      date.to_tomorrow
    end
    arrears[0] = arrears[0].last_year
    arrears
  end

  # Creating the end pairs for advance date ranges.
  # @dates_in_year: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  F -1D   G -1D   H -1D   E -1D +1Y
  def advance_end
    advance = @dates_in_year.rotate(1).map do |date|
      date.to_yesterday
    end
    advance[-1] = advance[-1].next_year
    advance
  end

  def <=> other
    [@dates_in_year.each] <=> [other.dates_in_year.each]
  end
end
