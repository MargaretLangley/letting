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
  attr_reader :arrears, :earliest_date_due, :invoice_date, :products, :transaction  # rubocop: disable Metrics/LineLength
  def initialize(invoice_date:, arrears:, transaction:)
    @invoice_date = invoice_date
    @arrears = arrears
    @transaction = transaction

    @products = make_products
    @earliest_date_due = earliest_transaction_date
  end

  def invoice(*)
    {
      products: products,
      total_arrears: total_arrears,
      earliest_date_due: earliest_date_due,
    }
  end

  private

  def make_products
    products_balanced(product_arrears_maker +
                      transaction.debits.map do |debit|
                        Product.new debit.to_debitable
                      end)
  end

  def product_arrears_maker
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

  def total_arrears
    products.last.balance
  end

  def earliest_transaction_date
    transaction.debits.map(&:on_date).min
  end
end
