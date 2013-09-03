module DB
  class DayMonth
    attr_reader :day
    attr_reader :month

    def self.from_day_month day, month
      new day, month
    end

    def initialize day, month
      @day = day
      @month = month
    end
  end
end