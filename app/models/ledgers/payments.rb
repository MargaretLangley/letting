#####
#
# Payments
#
# Class for handling the payments index
#
# The index of payments requires collecting the payments that occur on a day
# and performing operations on them: negating and summation.
#
# last_booked_on - The index defaults to the last day that a payment could be
#                made.
#
#####
#
class Payments
  def initialize payments
    @payments = payments.map(&:negate)
  end

  def to_a
    @payments
  end

  def sum
    @payments.map(&:amount).inject(0, &:+)
  end

  def self.on date: Date.current.to_s
    return Payment.none unless SearchDate.new(date).valid_date?
    Payment.includes(account: [:property])
           .where(booked_on: SearchDate.new(date).day_range)
  end

  def self.last_booked_on
    return Date.today.to_s if Payment.count.zero?
    Payment.order('booked_on DESC').first.booked_on.to_date.to_s
  end

  def self.last
    return :no_last_payment if Payment.count.zero?
    Payment.order('booked_on DESC').first
  end
end
