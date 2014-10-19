####
#
# RepeatDate
#
# Abstraction for repeating dates (day month combinations
# that appear every year).
#
# Wrapping a date up so that it can worry about the end of month and I just add
# and remove days.
#
####
#
class RepeatDate
  include Comparable
  A_YEAR_AWAY_FROM_LEAP_DAY = 2002
  attr_reader :day, :month, :year, :date
  def initialize day:   Time.now.day,
                 month: Time.now.month,
                 year:  A_YEAR_AWAY_FROM_LEAP_DAY,
                 date:  nil
    if date
      @date = date
    else
      @date = Date.new(year, month, day)
    end
  end

  def day
    @date.day
  end

  def month
    @date.month
  end

  def year
    @date.year
  end

  def yesterday
    @date -=  1.day
    self
  end

  def tomorrow
    @date += 1.day
    self
  end

  def last_year
    @date -= 1.year
    self
  end

  def next_year
    @date += 1.year
    self
  end

  delegate :to_s, to: :date

  def <=> other
    return nil unless other.is_a?(self.class)
    [year, month, day] <=> [other.year, other.month, other.day]
  end
end
