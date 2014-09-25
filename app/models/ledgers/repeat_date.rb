####
#
# RepeatDate
#
# Abstraction for repeating dates (day month combinations
# that appear every year).
#
# TODO: Do we need this abstraction?
#
####
#
class RepeatDate
  include Comparable
  attr_reader :date
  def initialize(day: Time.now.day,
                 month: Time.now.month,
                 year: Time.now.year,
                 date: nil)
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
    RepeatDate.new(date: @date - 1.day)
  end

  def tomorrow
    RepeatDate.new(date: @date + 1.day)
  end

  def last_year
    RepeatDate.new(date: @date - 1.year)
  end

  def next_year
    RepeatDate.new(date: @date + 1.year)
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [date] <=> [other.date]
  end
end
