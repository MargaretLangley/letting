#####
#
# Payments
#
# Class for handling the collection of payments
#
# to_a - converting to an array
# sum  - summing over the array
#
#####
#
class Payments
  attr_reader :payments

  def initialize payments
    @payments = payments
  end

  def to_a
    payments
  end

  def sum
    payments.map(&:amount).inject(0, &:+)
  end

  # The date a payment was last created_at
  # created_at - is the date a payment was entered and is unaffected by any
  #              booked_at date.
  #
  def self.last_created_at
    return :no_last_payment if Payment.count.zero?
    Payment.order('created_at DESC').first
  end
end
