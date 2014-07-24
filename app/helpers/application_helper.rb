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

  # Entity can have a number of parental association types
  # This will generate the type into a string so agents
  # and property can exist on the same page.
  #
  def entity_field_id entitieable, index
    "#{entitieable.class.to_s.underscore}_entity_#{index}"
  end

  def view_link model
    if model.new_record?
      link_to 'View', '#', class: 'simple-button float-right', disabled: true
    else
      link_to 'View', model, class: 'simple-button float-right'
    end
  end
end
