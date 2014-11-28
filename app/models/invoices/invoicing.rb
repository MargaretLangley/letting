####
#
# Invoicing
#
# A batch of invoices to bill customers.
#
# The user searches for property-ids within a date range that will be billed.
# InvoicesMaker returns invoices that are to be debited during the invoicing
# period.
#
# An invoice is the information required to print an invoice. Made up of
# property related information and the products (services) that are charged
# during the time period of the invoice.
#
class Invoicing < ActiveRecord::Base
  has_many :runs, dependent: :destroy, inverse_of: :invoicing
  validates :property_range, :period_first, :period_last, :runs, presence: true
  scope :default, -> { order(period_first: :desc) }

  def period
    (period_first..period_last)
  end

  def period=(billing)
    self.period_first = billing.first
    self.period_last  = billing.last
  end

  # generate?
  # Does this invoicing have enough arguments to call generate on?
  # Nil values for property_range and period are nil cause problems.
  #
  def generate?
    property_range && period.first && period.last
  end

  # actionable?
  # Would this invoicing create an invoice at all?
  #
  def actionable?
    runs.present? && runs.first.actionable?
  end

  def generate invoice_date: Time.zone.today
    runs.build.prepare invoice_date: invoice_date
  end
end
