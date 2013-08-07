module ApplicationHelper

  def format_empty_string_as_dash a_string
    a_string.blank? ? '-'  : a_string
  end
end
