####
#
# module DebtGeneratorsHelper
#
# Provides a wrapper for the debt_generator class
#
module DebtGeneratorsHelper

  def search_range
    "#{@debt_generator.start_date.to_formatted_s(:day_and_month)} - " +
    "#{@debt_generator.end_date.to_formatted_s(:day_and_month)}"
  end

end
