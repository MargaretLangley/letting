#####
#
# Utility class for leap_day
#
#####
#
class Cover
  def self.leap_day?(range:)
    return false unless Date.leap?(range.first.year) ||
                        Date.leap?(range.last.year)
    if Date.leap?(range.first.year)
      return (range.first..range.last).cover? Date.new(range.first.year, 2, 29)
    else
      return (range.first..range.last).cover? Date.new(range.last.year, 2, 29)
    end
  end
end
