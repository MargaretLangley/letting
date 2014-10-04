module DB
  ####
  #
  # DayMonth
  #
  # Why does the class exist
  #
  # Wraps up day and month pairings used in charge import
  #
  # How does it fit into the larger system
  #
  # I was considering using the class elsewhere but only seen to use it
  # for the import.
  ####
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
