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
    @products = make_products
  end

  def invoice(*)
    products
  end

  private

  def make_products
    product_arrears_maker + transaction.debits.map do |debit|
      Product.new debit.to_debitable
    end
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
end
