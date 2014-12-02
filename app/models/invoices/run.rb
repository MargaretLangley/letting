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
  def prepare(invoice_date:, comments:)
    self.invoice_date = invoice_date

    if first_run
      self.invoices = invoices_maker(comments: comments)
    else
      self.invoices = rerun invoicing.runs.first.invoices, comments: comments
    end
  end

  #
  # actionable?
  # Are the accounts invoiceable?
  # prepare must be called before actionable will return correct result
  #
  def actionable?
    invoices.select(&:actionable?).present?
  end

  private

  def init
    self.invoice_date = Time.zone.today if invoice_date.blank?
  end

  def first_run
    self == invoicing.runs.first
  end

  #
  # rerun
  # update the invoice - allowing for any payments and date changes
  #
  def rerun(invoices, comments:)
    invoices.map do |invoice|
      invoice_remaker(invoice,
                      comments: comments,
                      products: remaker_products(invoice))
    end
  end

  def invoices_maker comments: []
    InvoicesMaker.new(property_range: invoicing.property_range,
                      period: invoicing.period,
                      invoice_date: invoice_date,
                      comments: comments)
                      .compose
                      .invoices
  end

  def invoice_remaker(invoice, comments:, products:)
    InvoiceRemaker.new(template_invoice: invoice,
                       comments: comments,
                       products: products).compose
  end

  def remaker_products invoice
    ProductsMaker.new(invoice_date: invoice_date,
                      arrears: invoice.account.balance(to_date: invoice_date),
                      transaction: invoice.debits_transaction).invoice
  end
end
