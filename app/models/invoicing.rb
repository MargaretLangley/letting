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
  has_many :runs, dependent: :destroy
  validates :property_range, :period_first, :period_last, :runs, presence: true
  scope :default, -> { order(period_first: :desc) }

  def period
    (period_first..period_last)
  end

  def period=(billing)
    self.period_first = billing.first
    self.period_last  = billing.last
  end

  # actionable?
  # is this invoicing in use, in action, at all?
  #
  def actionable?
    runs.first.actionable?
  end

  def generate
    if runs.empty?
      runs.build.prepare
    else
      runs.build.rerun runs.first
    end
  end
end
