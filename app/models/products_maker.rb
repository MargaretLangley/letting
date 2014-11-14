###
# ProductsMaker
#
# Assembles products from arrears for the invoicing.
#
# @invoice_date - the date the invoice is dated with.
#                 Used for the arrears date, if any
#
# @products     - generated products
#
# @earliest_date_due - first product date
#
###
# t
class ProductsMaker
  attr_reader :earliest_date_due, :invoice_date, :products
  def initialize(invoice_date:, arrears:, transaction:)
    @invoice_date = invoice_date
    @products = product_arrears_maker(arrears: arrears) +
                transaction.debits.map { |debit| Product.new debit.to_debitable } # rubocop: disable Metrics/LineLength
    products_balanced products
    @earliest_date_due = transaction.debits.map(&:on_date).min
  end

  def invoice(*)
    {
      products: products,
      total_arrears: total_arrears,
      earliest_date_due: earliest_date_due,
    }
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

  def total_arrears
    products.last.balance
  end
end
