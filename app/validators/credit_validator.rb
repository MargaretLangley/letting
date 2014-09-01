####
#
# CreditValidator
#
# Validates that the amount is valid
#
# Usage
#
# class Balance
#   validates :amount, credit: true
# end
#
# Further Reading http://api.rubyonrails.org/v4.1.1/classes/ActiveModel/Validator.html
#
# Params are passed to classes as strings. However, by the time they
# are validated they have been parsed and the value is a decimal.
#
####
#
class CreditValidator < ActiveModel::EachValidator
  # string such as 'nnn' converts to 0
  # Fortunately, 0 is invalid - otherwise opaque string matching required.
  #
  def validate_each(record, attribute, value)
    return if value && ( value != 0 && value > -100_000 && value < 100_000)

    record.errors.add attribute, error_message(value)
  end

  def error_message value
    'must be a none-zero decimal number between -100,000 and 100,000.'\
    " Currently: #{value.nil? ? 'Empty' : value * -1}"
  end
end
