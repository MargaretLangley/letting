require 'rails_helper'

module SalientDate
  def salient_date_range(start_date:, end_date:)
    if start_date && end_date &&
      start_date.year == Date.current.year &&
      end_date.year   == Date.current.year &&
      start_date.year == end_date.year
      "#{safe_date(date: start_date, format: :month_date)} - "\
      "#{safe_date(date: end_date, format: :month_date)}"
    else
      "#{safe_date(date: start_date, format: :short)} - "\
      "#{safe_date(date: end_date, format: :short)}"
    end
  end

  def safe_date(date:, format:)
    return '' unless date
    "#{I18n.l date, format: format}"
  end
end
