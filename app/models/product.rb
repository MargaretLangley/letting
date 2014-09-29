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

  def period
    (period_first..period_last)
  end

  def period=(bill_range)
    self.period_first = bill_range.first
    self.period_last  = bill_range.last
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [charge_type, date_due, amount, period] <=>
      [other.charge_type, other.date_due, other.amount, other.period]
  end
end
