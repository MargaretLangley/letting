####
#
# StringDate
#
# Safe Parsing of a string into a date.
#
####
#
class StringDate
  def initialize datestring
    @datestring = datestring
  end

  def valid?
    Date.parse @datestring
    rescue
      false
  end

  def to_date
    Date.parse @datestring
    rescue
      nil
  end
end
