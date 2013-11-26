####
#
# The Account is a summation of charges, debits, and credits on a property.
#
# The property is the
# a property should become due a charge.
#
# The account has one property. A property has a number of charges.
# The charges generate debits and credits are made to cover these debits.
#
# Definition
#
# Accounts
# Receivable - money owed by customer for a service that has been delivered
#              but not paid for.
#
# Advanced Payments
#
# If I want to apply money in advance to a charge_type then need to break
# payment into sub-payment.
#
# Subpayment must be passed to payment as when need saving of subpayment at
# same time as payment (transactional).
#
# credit differs from advanced credit:
#
# We don't know how many credits will be generated from an advanced credit.
# If we choose to make the advance behaviour into credit. Credit would have to
# mutate in value remaining to pay off debts and duplicate it self in some way
# as you would need multiple credits if it covered multiple payments.
#
####
#
class Account < ActiveRecord::Base
  belongs_to :property, inverse_of: :account
  has_many :debits, dependent: :destroy
  has_many :credits, dependent: :destroy
  accepts_nested_attributes_for :credits, allow_destroy: true
  has_many :payments, dependent: :destroy
  has_many :charges, dependent: :destroy do
    def prepare
      (size...MAX_CHARGES).each { build }
      each { |charge| charge.prepare }
    end

    def clear_up_form
      each { |charge| charge.clear_up_form }
    end
  end
  MAX_CHARGES = 4
  accepts_nested_attributes_for :charges, allow_destroy: true

  def prepare_debits date_range
    charges.select{ |charge| charge.first_free_chargeable? date_range }
      .map do |charge|
        Debit.new(charge.first_free_chargeable(date_range).to_hash)
    end
  end

  def prepare_credits
    [ prepare_credits_to_receivables + prepare_advanced_credits ]
      .compact.reduce([], :|)
  end

  def prepare_for_form
    charges.prepare
  end

  def clear_up_form
    charges.clear_up_form
  end

  def self.by_human_ref human_ref
    Account.joins(:property).find_by(properties: { human_ref: human_ref })
  end

  private

  # call once per request
  #
  def prepare_credits_to_receivables
    receivables.map { |debit| build_credit_from_debit(debit) }
  end

  def receivables
    debits.reject(&:paid?)
  end

  # def payables
  #   credits.reject(&:paid?)
  # end

  def build_credit_from_debit debit
    Credit.new account_id: id,
               debit: debit,
               charge_id: debit.charge_id,
               advanced: false
  end

  def prepare_advanced_credits(date_range = Date.current..Date.current + 1.years)
    charges.select{ |charge| charge.first_chargeable?(date_range) }
           .map do |charge|
             build_advanced_credit_from_chargeable \
             charge.first_chargeable(date_range)
           end
  end

  def build_advanced_credit_from_chargeable chargeable
    Credit.new chargeable.to_hash on_date: Date.current,
                                  advanced: true,
                                  amount: 0
  end
end
