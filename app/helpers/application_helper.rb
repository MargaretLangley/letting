require_relative '../../lib/modules/salient_date'

####
#
# ApplicationHelper
#
# Shared helper methods
#
####
#
module ApplicationHelper
  include SalientDate
  def format_empty_string_as_dash a_string
    a_string.blank? ? '-'  : a_string
  end

  def payment_types
    Charge::PAYMENT_TYPE.map { |type| [type.humanize, type] }
  end
end
