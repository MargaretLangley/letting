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
           .includes([property: [:entities,
                                 :address,
                                 client: [:address, :entities],
                                 agent:  [:address, :entities]]],
                     :credits,
                     :charges,
                     :debits)
           .select { |account| account.invoice? billing_period: period }
  end

  def make_invoices(accounts:)
    accounts.map { |account| make_invoice account: account }
  end

  def make_invoice(account:)
    invoice = Invoice.new
    invoice.prepare invoice_date: invoice_date
    invoice.property account.property.invoice billing_period: period
    invoice.products = products_maker account.invoice(billing_period: period)
                                             .except(:total_arrears)
    invoice.total_arrears = \
      account.invoice(billing_period: period)[:total_arrears]
    invoice.client account.property.client.invoice billing_period: period
    invoice
  end

  def products_maker(arrears:, debits:)
    products = product_arrears_maker(arrears: arrears) +
                 debits.map { |debit| Product.new debit.to_debitable }
    products_balanced products
  end

  def product_arrears_maker(arrears:)
    product_arrears = []
    if arrears.nonzero?
      product_arrears = [Product.new(charge_type: 'Arrears',
                                     date_due: invoice_date,
                                     amount: arrears)]
    end
    product_arrears
  end

  def products_balanced products
    total = 0
    products.map do |product|
      product.balance = total += product.amount
      product
    end
  end
end
