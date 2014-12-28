# InvoicesMaker
#
# Makes invoices given invoicing, invoice_date and comments.
#
# InvoicesMaker takes invoicing information and other associated information
# and creates invoices for the matching accounts.
#
# Run requires the invoices and makes a call to objects that create invoices
# for it. This is responsible for creating invoices from user supplied
# arguments(account_range and time period) as well as invoice_date and comments.
#
# property     - the property to invoice
# invoice_date - the date which the invoice is dated on
#                affects the date which the arrears balance is created for.
# comments     - information string to be applied to the invoice.
#
class InvoicesMaker
  attr_reader :comments, :invoice_date, :invoicing

  def initialize invoicing:, invoice_date: Time.zone.today, comments: []
    @invoicing = invoicing
    @invoice_date = invoice_date
    @comments = comments
  end

  def invoices
    @invoices ||= invoicing
                  .accounts
                  .map { |account| invoice_maker(account: account) }
  end

  private

  def invoice_maker(account:)
    (invoice = Invoice.new)
      .prepare property: account.property.invoice,
               snapshot: snapshot_maker(account),
               invoice_date: invoice_date,
               comments: comments
    invoice.deliver = snapshot_maker(account).debits? ? :mail : :retain
    invoice
  end

  # snapshot - the debits created during the invoicing period
  #
  def snapshot_maker(account)
    snapshot = Snapshot.match(account: account, period: invoicing.period).first
    snapshot = SnapshotMaker.new(account: account,
                                 debit_period: invoicing.period)
               .invoice unless snapshot
    snapshot
  end
end
