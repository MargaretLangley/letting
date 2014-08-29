####
# PropertiesHelper
#
# First items cannot be hidden - everything else can.
# Wrapping css style - js-revealable is alias for hidden.
#
####
#
module PropertiesHelper
  def hide_new_record_unless_first record, index
    record.new_record? && index > 0 ? 'js-revealable' : ''
  end
end
