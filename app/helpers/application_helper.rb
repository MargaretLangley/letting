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
