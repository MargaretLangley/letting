###
# ProductsMaker
#
# Assembles products from arrears for the invoicing.
#
###
# t
class ProductsMaker
  attr_reader :invoice_date, :products
  def initialize(invoice_date:, arrears:, transaction:)
    @invoice_date = invoice_date
    @products = product_arrears_maker(arrears: arrears) +
                transaction.debits.map { |debit| Product.new debit.to_debitable } # rubocop: disable Metrics/LineLength
    products_balanced products
  end

  def invoice(*)
    { products: products }
  end

  private

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
