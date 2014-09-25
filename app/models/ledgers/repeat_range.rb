####
#
# RepeatRange
#
# Factory to make billing period objects
#
####
#
#
module RepeatRange
  def self.for name:, dates: nil, repeat_dates: nil
    dates_in_year = []
    dates_in_year = dates.map { |date| RepeatDate.new date: date } if dates
    dates_in_year = repeat_dates if repeat_dates
    klass_for(name).new(repeat_dates: dates_in_year)
  end

  def self.klass_for name
    case name
    when 'Advance'
      Advance
    when 'Arrears'
      Arrears
    when 'Mid-Term'
      fail 'Mid-Term missing'
    else
      fail 'Unknown charged_in type'
    end
  end
end
