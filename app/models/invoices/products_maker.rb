###
# ProductsMaker
#
# Assembles products from arrears and from the invoiceable debits.
# Calculates products, total_arrears and earliest date for a product.
#
# @invoice_date - the date the invoice is dated with.
#                 Used for the arrears date, if any
#
# @products     - generated products
#
# @earliest_date_due - first product date
#
###
#
class ProductsMaker
  attr_reader :arrears, :invoice_date, :products, :transaction
  def initialize(invoice_date:, arrears:, transaction:)
    @invoice_date = invoice_date
    @arrears = arrears
    @transaction = transaction
  end

  def invoice(*)
    products
  end

  def debits?
    product_debits.present?
  end

  def self.arrears(date_due:, amount:)
    Product.new charge_type: 'Arrears',
                date_due: date_due,
                automatic_payment: false,
                amount: amount
  end

  private

  def products
    @products ||= product_arrears + product_debits
  end

  def product_arrears
    product_arrears = []
    if arrears.nonzero?
      product_arrears = [ProductsMaker.arrears(date_due: invoice_date,
                                               amount: arrears)]
    end
    product_arrears
  end

  def product_debits
    transaction.debits.map do |debit|
      Product.new debit.to_debitable
    end
  end
end
