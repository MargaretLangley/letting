# Advance & arrears
# Advance and arrears - gets dates turns them into periods
# indexes the period on either the start or end date
#
# FixedTerm
# * periods cannot be calculated from the repeat_dates
# * Use Repeat_dates to find matching periods.
#
# How to get period information from persistent store
# 1) fixed_term table with id and up to 4 columns for dates to match on
# 2) fixed_term_period with:
#      - FK - fixed_term table foreign key
#      - due_date - date which the charge becomes debited.
#      - period, two dates, which is associated with the due_date
#
# When you query you have a billed_date and it matches the due_date
# This returns the periods.

class FixedTerm
  attr_reader :periods, :repeat_dates

  def initialize(repeat_dates:)
    @repeat_dates = repeat_dates
    periods unless repeat_dates.empty?
  end

  def duration(within:)
    found_period = periods.find do |period|
      period.first == RepeatDate.new(date: within)
    end
    return :missing_due_on unless found_period
    make_duration start: within, length: period_length(period: found_period)
  end

  private

  # Advance range pairs
  # Take two pairs of dates and make pairings
  #
  def periods
    x = march
    byebug
    x
  end

  def march
    {
      # {[RepeatDate.new(month: 3, day: 25),RepeatDate.new(month: 9, day: 29)] => 8 },
      # {[RepeatDate.new(month: 6, day: 24),RepeatDate.new(month: 12, day: 25)] => 7 }
    }
    # 25th Mar, 29th Sept =>  26/12/2014—24/6/2015
    # 24th Jun, 25th Dec =>  25/6/2014—25/12/2014
  end
end
