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
      each &:prepare
    end

    def clear_up_form
      each &:clear_up_form
    end
  end
  MAX_CHARGES = 4
  accepts_nested_attributes_for :charges, allow_destroy: true

  def prepare_debits date_range
    charges.map do |charge|
      charge.next_chargeable(date_range).map { |chargeable| Debit.new(chargeable.to_hash) }
    end.flatten
  end

  def prepare_credits
    charges.map { |charge| create_credit charge }
  end

  def prepare_for_form
    charges.prepare
  end

  def clear_up_form
    charges.clear_up_form
  end

  def balance date
    date ||= Date.current
    credits.select { |c| c.on_date <= date }.map { |c| c.amount }.inject(0,:+) -
    debits.select { |d| d.on_date <= date }.map { |d| d.amount }.inject(0,:+)
  end

  def self.by_human_ref human_ref
    Account.joins(:property).find_by(properties: { human_ref: human_ref })
  end

  private

  def create_credit charge
    credits.build charge: charge, on_date: Date.current, amount: charge.amount
  end
end
