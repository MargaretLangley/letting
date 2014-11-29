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
  belongs_to :invoicing, inverse_of: :runs
  has_many :invoices, dependent: :destroy, inverse_of: :run

  validates :invoice_date, :invoices, presence: true
  after_initialize :init

  #
  # prepare
  # assigns required attributes and create the invoices required for invoice
  #
  # invoice_date - date to appear on the invoice
  #
  def prepare(invoice_date:)
    return unless invoicing.generate?
    self.invoice_date = invoice_date

    if first_run
      self.invoices = make_invoices
    else
      self.invoices = rerun invoicing.runs.first
    end
  end

  #
  # rerun
  # update the invoice - allowing for any payments and date changes
  #
  def rerun run
    run.invoices.map(&:remake)
  end

  #
  # actionable?
  # Are the accounts invoiceable?
  #
  def actionable?
    make_invoices.size > 0
  end

  private

  def init
    self.invoice_date = Time.zone.today if invoice_date.blank?
  end

  def first_run
    self == invoicing.runs.first
  end

  def make_invoices
    InvoicesMaker.new(property_range: invoicing.property_range,
                      period: invoicing.period,
                      invoice_date: invoice_date)
                      .compose
                      .invoices
  end
end
