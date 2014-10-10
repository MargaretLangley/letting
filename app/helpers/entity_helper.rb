###
#
# EntityHelper
#
# View logic over business, entity, object logic.
#
# View: entities/_form.html.erb
# Behaviour: reveal.js (js-reveal-link, js-hide-link & js-destroy-link)
#
####
#
module EntityHelper
  def first_record? index
    return false if index > 0
    true
  end

  # Entity can have a number of parental association types
  # This will generate the type into a string so agents
  # and property can exist on the same page.
  #
  def entity_field_id entitieable, index
    "#{entitieable.class.to_s.underscore}_entity_#{index}"
  end

  # If we are deleting a record do we hide it or do we destroy it
  # - New records have not been persisted and can be hidden and
  # revealed without worrying about destroying the record.
  # - Records that have been saved previously - will need to be
  # flagged to be deleted.
  #
  # Functionality all handled by js - currently reveal.js
  #
  def hide_or_destroy record
    record.new_record? ? 'js-hide-link' : 'js-destroy-link'
  end
end
