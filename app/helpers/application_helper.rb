####
#
# ApplicationHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/MethodLength
#
####
#
module ApplicationHelper
  def format_empty_string_as_dash a_string
    a_string.blank? ? '-'  : a_string
  end

  def minimum_range_information(start_date:, end_date:)
    if start_date.year == end_date.year
      "#{I18n.l start_date, format: :month_date} - "\
        "#{I18n.l end_date, format: :month_date}"
    else
      "#{I18n.l start_date, format: :short} - "\
        "#{I18n.l end_date, format: :short}"
    end
  end

  def view_link model
    if model.new_record?
      link_to fa_icon('file'),
              '#',
              class: 'simple-button float-right',
              disabled: true, title: 'View file (disabled)'
    else
      link_to fa_icon('file'),
              model,
              class: 'simple-button float-right',
              title: 'View file'
    end
  end
end
