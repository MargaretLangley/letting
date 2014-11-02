####
#
# Invoicing
#
# A batch of invoices to bill customers.
#
# The user searches for property-ids within a date range that will be billed.
# InvoicingMaker returns invoices that are to be debited during the invoicing
# period.
#
# An invoice is the information required to print an invoice. Made up of
# property related information and the products (services) that are charged
# during the time period of the invoice.
#
class Invoicing < ActiveRecord::Base
  has_many :invoices
  validates :property_range, :period_first, :period_last, :invoices,
            presence: true
  def period
    (period_first..period_last)
  end

  def period=(billing)
    self.period_first = billing.first
    self.period_last  = billing.last
  end

  def generate
    self.invoices = InvoicingMaker.new(property_range: property_range,
                                       period: period)
                                      .compose
                                      .invoices
  end
end
