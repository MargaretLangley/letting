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
  attr_reader :property_range, :period, :invoices
  def initialize(property_range:, period:)
    @property_range = property_range
    @period = period
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
           .select { |account| account.invoice? billing_period: period }
  end

  def make_invoices(accounts:)
    accounts.map { |account| make_invoice account: account }
  end

  def make_invoice(account:)
    invoice = Invoice.new
    invoice.prepare
    invoice.property account.property.invoice billing_period: period
    invoice.account account.invoice billing_period: period
    invoice.client account.property.client.invoice billing_period: period
    invoice
  end
end
