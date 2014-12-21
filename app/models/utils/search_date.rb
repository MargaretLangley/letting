####
#
# SearchDate
#
# Validates a date and converts it into a datetime covering
# that date. Used for Payment search which requires you to
# search a day.
#
# Matching a DateTime is awkward - either you round it to the nearest date
# (can be a problem as it's impossible to reverse the process) or you form
# a range. This is the range solution.
#
####
#
class SearchDate
  attr_reader :date

  def initialize date
    @date = date
  end

  def valid_date?
    date.present? && parse_date?
  end

  def day_range
    date.to_datetime.beginning_of_day..date.to_datetime.end_of_day
  end

  private

  def parse_date?
    DateTime.parse date
    rescue
      false
  end
end
