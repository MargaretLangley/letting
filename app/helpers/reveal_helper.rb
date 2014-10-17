####
# RevealHelper
#
# Helper to wrap logic for adding and removing collection elements through
# JQuery - reveal collection elements that are hidden on the form.
# Interacts with reveal.js and forms (charges, entities, cycle)
#
# Introduction
# js-group-toggle - the js acts within the box.
# js-enclosed-toggle - the collection element acts within js-group-toggle box.
#
# When you 'add (make visible)' an element we find the closest js-group-toggle
# from the add button and the reveal the first hidden element.
#
# When you 'delete (hide)' an element we find the closest js-enclosed box
# hide it, clear it.
#
####
#
module RevealHelper
  # First items cannot be hidden - everything else can.
  # Wrapping css style - js-revealable is alias for hidden.
  def hide_extra_new_records(record:, index:)
    record.new_record? && index > 0 ? 'js-revealable' : ''
  end

  def first_record?(index:)
    return false if index > 0
    true
  end

  # If we are deleting a record do we hide it or do we destroy it
  # - New records have not been persisted and can be hidden and
  # revealed without worrying about destroying the record.
  # - Records that have been saved previously - will need to be
  # flagged to be deleted.
  #
  # Functionality all handled by js - currently reveal.js
  #
  def hide_or_destroy(record:)
    record.new_record? ? 'js-hide-link' : 'js-destroy-link'
  end
end
