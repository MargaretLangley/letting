#
# BatchMonths
#
# Encapsulate the payment periods - which are 6 month
# periods.
#
class BatchMonths
  attr_reader :first, :last, :now
  MAR = 3
  JUN = 6
  SEP = 9
  DEC = 12

  def initialize(first:, last:, now:)
    @first = first
    @last = last
    @now = now
  end

  def now_to_s
    Date::ABBR_MONTHNAMES[now]
  end

  def first_to_s
    Date::ABBR_MONTHNAMES[first]
  end

  def range
    [first, last]
  end

  def last_to_s
    Date::ABBR_MONTHNAMES[last]
  end

  def to_s join: '/'
    "#{first_to_s}#{join}#{last_to_s}"
  end
end
