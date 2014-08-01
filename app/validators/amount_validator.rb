####
#
# AmountValidator
#
# Validates that the amount is valid
#
# Usage
#
# class Balance
#   validates :amount, amount: true
# end
#
# Further Reading http://api.rubyonrails.org/v4.1.1/classes/ActiveModel/Validator.html
#
# Params are passed to classes as strings. However, by the time they
# are validated they have been parsed and the value is a decimal.
#
####
#
class AmountValidator < ActiveModel::EachValidator
  # if the validation fails we add an error to the record for this attribute.
  #
  def validate_each(record, attribute, value)
    return if value && value.to_s =~ /\A\d+??(?:\.\d{0,})?\z/

    record.errors.add attribute, error_message(value)
  end

  def error_message value
    "must be a decimal number greater than or equal to 0. Currently: #{value}"
  end
end
