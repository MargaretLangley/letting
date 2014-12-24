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
  attr_reader :invoice, :comments, :invoice_date, :products
  def initialize(invoice:,
                 invoice_date: Time.zone.today,
                 comments: [],
                 products:)
    @invoice = invoice
    @comments = comments
    @invoice_date = invoice_date
    @products = products
  end

  #
  # compose
  # Repackages existing invoice with run specific arguments.
  #
  def compose
    remake
  end

  private

  def remake new_invoice: Invoice.new
    new_invoice
      .prepare account: invoice.account,
               invoice_date: invoice_date,
               property: invoice.property,
               debits_transaction: invoice.debits_transaction,
               comments: comments,
               products: products
  end
end
