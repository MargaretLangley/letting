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
    unless value && value.to_s =~ /\A\d+??(?:\.\d{0,2})?\z/ && value >= 0
      record.errors[attribute] << error_message
    end
  end

  def error_message
    'Amount must be a decimal number greater than 0.'
  end
end
