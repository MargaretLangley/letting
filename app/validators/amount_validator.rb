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
# are validated they have been parsed and the value is type coerced.
# 'blah' is_a? String
# 100.99 is_a? Float
#
####
#
class AmountValidator < ActiveModel::EachValidator
  # if the validation fails we add an error to the record for this attribute.
  #
  def validate_each(record, attribute, value)
    return if value &&
              (value.is_a? Numeric) &&
              (value != 0 && value > -100_000 && value < 100_000)

    record.errors.add attribute, error_message(value)
  end

  def error_message value
    'must be a none zero decimal between -£100,000 and £100,000.' \
    " Currently: #{value}"
  end
end
