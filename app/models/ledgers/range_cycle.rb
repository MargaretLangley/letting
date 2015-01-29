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
    'advance' => Advance,
    'arrears' => Arrears,
  }

  def self.for(name:, dates:)
    SPECIALIZED_CLASSES[name]
      .new repeat_dates: dates.map { |date| RepeatDate.new date: date }
  end
end
