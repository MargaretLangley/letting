Date::DATE_FORMATS[:day_and_month] = lambda { |date| date.strftime("#{date.day.ordinalize} %b") }
