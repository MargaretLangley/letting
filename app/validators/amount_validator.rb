####
#
# AmountValidator
#
# Validates that the amount is valid
#
# Params are passed to classes as strings. However, by the time they
# are validated they have been parsed and the value is a decimal.
#
####
#
class AmountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value && value.to_s =~ /\A\d+??(?:\.\d{0,})?\z/ && value >= 0
    record.errors[attribute] << error_message(value)
  end

  def error_message value
    "must be a decimal number greater than or equal to 0. Currently: #{value}"
  end
end
