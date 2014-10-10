####
# PropertiesHelper
#
# First items cannot be hidden - everything else can.
# Wrapping css style - js-revealable is alias for hidden.
#
####
#
module RevealHelper
  def hide_new_record_except_first builder
    builder.object.new_record? && builder.index > 0 ? 'js-revealable' : ''
  end

  def first_records? builder
    return false if builder.index > 0
    true
  end

  def last_record?(collection:, builder:)
    collection.last == builder.object
  end
end

