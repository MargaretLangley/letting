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
  belongs_to :invoice

  def period
    (period_first..period_last)
  end

  def period=(bill_range)
    self.period_first = bill_range.first
    self.period_last  = bill_range.last
  end

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
    "period: #{period_first}..#{period_last}"
  end
end
