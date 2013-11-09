####
#
# module DebitGeneratorsHelper
#
# Provides a wrapper for the debit_generator class
#
module DebitGeneratorsHelper
  def search_range
    "#{@debit_generator.start_date.to_formatted_s(:day_and_month)} - " +
    "#{@debit_generator.end_date.to_formatted_s(:day_and_month)}"
  end
end
