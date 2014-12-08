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
  include Comparable
  belongs_to :invoice, inverse_of: :products

  validates :amount, :charge_type, :date_due, presence: true
  validates :automatic_payment, inclusion: [true, false]
  def period
    (period_first..period_last)
  end

  def period=(bill_range)
    self.period_first = bill_range.first
    self.period_last  = bill_range.last
  end

  def balance
    invoice.products.balanced if invoice
    @balance
  end

  # Scope to return products that trigger the back page of the invoice
  # These are displayed on the backpage.
  #
  def self.back_page
    where(charge_type: ['Ground Rent', 'Garage Ground Rent'])
      .order(charge_type: :desc).first
  end

  attr_writer :balance

  # Does the product require additional explanation typically
  # on the back page of the invoice.
  #
  def back_page?
    charge_type == 'Ground Rent' || charge_type == 'Garage Ground Rent'
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
    "charge_type: #{charge_type} date_due: #{date_due} amount: #{amount} "\
    "period: #{period_first}..#{period_last}, balance: #{balance}"
  end
end
