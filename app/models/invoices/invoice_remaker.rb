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
  attr_reader :template, :comments, :invoice_date, :products
  def initialize(template_invoice:,
                 invoice_date: Time.zone.today,
                 comments: [],
                 products:)
    @template = template_invoice
    @comments = comments
    @invoice_date = invoice_date
    @products = products
  end

  #
  # compose
  # Make invoice from template invoice.
  #
  def compose
    remake
  end

  private

  def remake new_invoice: Invoice.new
    new_invoice
      .prepare account: template.account,
               invoice_date: invoice_date,
               property: template.property,
               debits_transaction: template.debits_transaction,
               comments: comments,
               products: products
  end
end
