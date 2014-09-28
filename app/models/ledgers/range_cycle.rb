####
#
# RangeCycle
#
# Factory to make billing period objects
#
####
#
#
module RangeCycle
  DEFAULT_CLASS = Advance
  SPECIALIZED_CLASSES = {
    'Advance' => Advance,
    'Arrears' => Arrears,
    'Mid-Term' => nil
  }

  def self.for name:, dates: nil, repeat_dates: nil
    dates_in_year = []
    dates_in_year = dates.map { |date| RepeatDate.new date: date } if dates
    dates_in_year = repeat_dates if repeat_dates
    (SPECIALIZED_CLASSES[name] || DEFAULT_CLASS)
      .new(repeat_dates: dates_in_year)
  end
end
