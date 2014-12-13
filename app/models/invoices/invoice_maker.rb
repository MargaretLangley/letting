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
# rubocop: disable  Metrics/MethodLength,  Metrics/LineLength, Metrics/ParameterLists
#
class InvoiceMaker
  attr_reader :comments, :account, :period, :invoice_date, :transaction, :products_maker
  def initialize(account:, period:,
                 invoice_date: Time.zone.today,
                 comments:,
                 transaction:,
                 products_maker:)
    @account = account
    @period = period
    @invoice_date = invoice_date
    @comments = comments
    @transaction = transaction
    @products_maker = products_maker
  end

  #
  # compose
  # Make invoices
  #
  def compose
    make_invoice
  end

  private

  def make_invoice
    (invoice = Invoice.new)
      .prepare account: account,
               invoice_date: invoice_date,
               property: account.property.invoice(billing_period: period),
               debits_transaction: transaction,
               comments: comments,
               products: products_maker.invoice
    invoice.mail = products_maker.debits?
    invoice
  end
end
