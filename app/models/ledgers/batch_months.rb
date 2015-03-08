#
# BatchMonths
#
# Encapsulate the payment periods - which are 6 month periods.
#
# charge_months has two main groups: Mar/Sep and Jun/Dec
# Mar/Sep which has sub-groups (Mar and Sep)
# Jun/Dec which has sub-groups (Jun and Dec)
#
#
#
class BatchMonths
  attr_reader :first, :last, :now
  MAR = 3
  JUN = 6
  SEP = 9
  DEC = 12

  def self.make(month:)
    BatchMonths.new BatchMonths.batch_arguments(month: month)
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

  def mar?
    now == MAR
  end

  def to_s join: '/'
    "#{first_to_s}#{join}#{last_to_s}"
  end

  def self.batch_arguments(month:)
    return { first: MAR, last: SEP, now: MAR  } if month == MAR
    return { first: JUN, last: DEC, now: JUN  } if month == JUN
    return { first: MAR, last: SEP, now: SEP  } if month == SEP
    return { first: JUN, last: DEC, now: DEC  } if month == DEC
    fail MonthUnknown, "Month argument #{month} is unknown"
  end

  private

  def initialize(first:, last:, now:)
    @first = first
    @last = last
    @now = now
  end
end
