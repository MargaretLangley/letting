####
#
# ApplicationHelper
#
# Shared helper methods
#
####
#
module ApplicationHelper
  def format_empty_string_as_dash a_string
    a_string.blank? ? '-'  : a_string
  end

  def view_link model
    if model.new_record?
      link_to 'View', '#', class: 'simple-button float-right', disabled: true
    else
      link_to 'View', model, class: 'simple-button float-right'
    end
  end
end
