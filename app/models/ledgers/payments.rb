#####
#
# Payments
#
# Class for handling the payments index
#
# The index of payments requires collecting the payments that occur on a day
# and performing operations on them: negating and summation.
#
# created_at = the day a record was created
# booked_at  = an accounting term to be the day a record was considered added
#              to the accounts.
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

  # Search for payments booked on this date
  # booked_on - is the date you want a payment to appear in the accounts
  #             user settable.
  #
  def self.booked_on date: Time.zone.today.to_s
    return Payment.none unless SearchDate.new(date).valid_date?

    Payment.includes(account: [:property])
      .where(booked_at: SearchDate.new(date).day_range)
  end

  # Search for payments created on this date.
  # created_on - is the date a payment was created - not user settable.
  #
  def self.created_on date: Time.zone.today.to_s
    return Payment.none unless SearchDate.new(date).valid_date?

    Payment.includes(account: [:property])
      .where(created_at: SearchDate.new(date).day_range)
  end

  # The date a payment was last booked_at
  # booked_at is an accounting date and does not have to be the created_at date.
  #
  def self.last_booked_at
    return Time.zone.today.to_s if Payment.count.zero?
    Payment.order('booked_at DESC').first.booked_at.to_date.to_s
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
