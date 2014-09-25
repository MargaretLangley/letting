####
#
# RepeatRange
#
####
#
#
class RepeatRange
  attr_reader :billed_on, :item, :dates_in_year

  def initialize name:, billed_on:, dates: nil, repeat_dates: nil
    @billed_on = billed_on
    @dates_in_year = []
    @dates_in_year = dates.map { |date| RepeatDate.new date: date } if dates
    @dates_in_year = repeat_dates if repeat_dates
    @item = klass_for(name).new(repeat_dates: dates_in_year)
  end

  def klass_for name
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

  def billing_period
    item.billing_period  billed_date: billed_on
  end
end
