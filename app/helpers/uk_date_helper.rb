# formates date european way
module UkDateHelper
  def display_uk_date(input_date)
    input_date.strftime('%d:%m:%Y' )
  end
end
