# ReRunMaker
#
# Makes invoices given previously created invoices, comments and date arguments.
#
# ReRunMaker takes invoicing information and other associated information
# and creates invoices.
#
#
class ReRunMaker
  attr_reader :comments, :invoice_date, :originals

  def initialize invoices:,
                 invoice_date: Time.zone.today,
                 comments: []
    @originals = invoices
    @invoice_date = invoice_date
    @comments = comments
  end

  # Invoices are repackaged for subsequent runs.
  #
  #
  def invoices
    @invoices ||= originals
                  .map { |invoice| invoice_remaker(invoice) }
  end

  private

  def invoice_remaker invoice
    InvoiceRemaker.new(invoice: invoice,
                       invoice_date: invoice_date,
                       comments: comments,
                       products: products_remaker(invoice)).compose
  end

  def products_remaker invoice
    ProductsMaker.new(invoice_date: invoice_date,
                      arrears: invoice.account.balance(to_date: invoice_date),
                      snapshot: invoice.snapshot)
      .invoice
  end
end
