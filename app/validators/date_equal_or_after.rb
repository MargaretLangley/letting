#
# Validates that the end date is after the start
#
# This is to avoid a gem dependency for a, currently, simple validation
#
class DateEqualOrAfter < ActiveModel::Validator
  def validate(record)
    return if record.start_date.nil? ||
              record.end_date.nil? ||
              record.start_date <= record.end_date
    record.errors[:end_date] << error_message
  end

  def error_message
    'End date must be after or equal to start date'
  end
end
