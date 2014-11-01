####
#
# InvoicingMaker
#
# Class responsible for making invoices within a property and invoicing period.
#
# Invoicing maintains property-ids within a date range that will be billed.
# period. This is passed to invoice maker, this class, which creates the
# invoices.
#
class InvoicingMaker
  attr_reader :property_range, :period, :invoices, :invoice_date
  def initialize(property_range:, period:)
    @property_range = property_range
    @period = period
    @invoice_date = Date.current
  end

  def generate
    @invoices = \
      make_invoices accounts: generateable_accounts(range: property_range)
    self
  end

  def generateable?
    generateable_accounts.present?
  end

  private

  def generateable_accounts range: property_range
    Account.between?(range)
           .includes([property: property_includes], :credits, :charges, :debits)
           .select do |account|
             DebitMaker.new(account: account, debit_period: period)
               .make_debits?
           end
  end

  def make_invoices(accounts:)
    accounts.map { |account| make_invoice account: account }
  end

  def make_invoice(account:)
    (invoice = Invoice.new).prepare \
      invoice_date: invoice_date,
      property: account.property.invoice(billing_period: period),
      products: ProductsMaker.new(invoice_date: invoice_date,
                                  **DebitMaker.new(account: account,
                                                   debit_period: period)
                                              .invoice).invoice
    invoice
  end

  def property_includes
    [:entities, :address,
     client: [:address, :entities],
     agent:  [:address, :entities]]
  end
end
