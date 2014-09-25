####
#
# RepeatRange
#
####
#
#
class RepeatRange
  attr_reader :charged_in, :billed_on, :dates_in_year

  def initialize charged_in:, billed_on:, dates: nil, repeat_dates: nil
    @charged_in = charged_in
    @billed_on = billed_on
    @dates_in_year = []
    @dates_in_year = dates.map { |date| RepeatDate.new date: date } if dates
    @dates_in_year = repeat_dates if repeat_dates
  end

  def billing_period
    case charged_in
    when 'Advance'
      advance = Advance.new(repeat_dates: dates_in_year)
      advance.billing_period billed_date: billed_on
    when 'Arrears'
      arrears = Arrears.new(repeat_dates: dates_in_year)
      arrears.billing_period billed_date: billed_on
    when 'Mid-Term'
      fail 'Mid-Term missing'
    else
      fail 'Unknown charged_in type'
    end
  end
end
