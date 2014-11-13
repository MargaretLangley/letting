####
#
# Run
#
# Each Invoicing is normally printed twice.
# Between runs the debits won't change but the payments will.
# Each run updates the payments, credits, which in turn affects the outputted
# invoice.
#
####
#
class Run < ActiveRecord::Base
  belongs_to :invoicing
  has_many :invoices

  validates :invoices, presence: true
  def prepare
    self.invoices = InvoicingMaker.new(property_range: invoicing.property_range,
                                       period: invoicing.period)
                                      .compose
                                      .invoices
  end

  def actionable?
    invoices.size > 0
  end
end
