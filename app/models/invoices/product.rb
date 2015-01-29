####
#
# Product
#
# Product is a line item on the invoice.
#
# Invoices are created of property related information and the billed charges
# for a period. The product are these billed charges plus any arrears.
#
####
#
class Product < ActiveRecord::Base
  enum payment_type: [:manual, :automatic]
  include Comparable
  belongs_to :invoice, inverse_of: :products

  validates :amount, :charge_type, :date_due, presence: true
  validates :payment_type, inclusion: { in: payment_types.keys }
  def period
    (period_first..period_last)
  end

  def period=(bill_range)
    self.period_first = bill_range.first
    self.period_last  = bill_range.last
  end

  # Wrapper for the arguments required for an Arrears product item.
  # All the other product items are taken from the debit.
  #
  def self.arrears(account:, date_due:)
    Product.new charge_type: ChargeTypes::ARREARS,
                date_due: date_due,
                payment_type: 'automatic',
                amount: account.balance(to_time: date_due),
                balance: account.balance(to_time: date_due)
  end

  # Scope to return products that trigger the back page of the invoice
  # These are displayed on the backpage.
  #
  def self.page2
    where(charge_type: [ChargeTypes::GROUND_RENT,
                        ChargeTypes::GARAGE_GROUND_RENT])
      .order(charge_type: :desc).first
  end

  # Does the product require additional explanation typically
  # on the back page of the invoice.
  #
  def page2?
    [ChargeTypes::GROUND_RENT, ChargeTypes::GARAGE_GROUND_RENT]
      .include? charge_type
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [charge_type, date_due, amount, period_first, period_last] <=>
      [other.charge_type,
       other.date_due,
       other.amount,
       other.period_first,
       other.period_last]
  end

  def to_s
    "charge_type: #{charge_type} date_due: #{date_due} " \
    "amount: #{amount.round(2)} " \
    "period: #{period_first}..#{period_last}, " \
    "balance: #{balance ? balance.round(2) : ''}"
  end
end
