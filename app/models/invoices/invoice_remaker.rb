####
#
# InvoicesMaker
#
# Class responsible for making invoices within a property and invoicing period.
#
# Invoicing maintains property-ids within a date range that will be billed.
# period. This is passed to invoice maker, this class, which creates the
# invoices.
#
class InvoiceRemaker
  attr_reader :invoice_text, :comments, :invoice_date, :products
  def initialize(invoice_text:,
                 invoice_date: Time.zone.today,
                 comments: [],
                 products:)
    @invoice_text = invoice_text
    @comments = comments
    @invoice_date = invoice_date
    @products = products
  end

  #
  # compose
  # Make invoice from invoice_text invoice.
  #
  def compose
    remake
  end

  private

  def remake new_invoice: Invoice.new
    new_invoice
      .prepare account: invoice_text.account,
               invoice_date: invoice_date,
               property: invoice_text.property,
               debits_transaction: invoice_text.debits_transaction,
               comments: comments,
               products: products
  end
end
