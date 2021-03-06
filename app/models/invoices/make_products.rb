#
# Creates Products required, finally, for invoices
#
class MakeProducts
  attr_reader :account, :color, :debits, :invoice_date
  def initialize(account:, debits:, invoice_date:, color: :blue)
    @account = account
    @invoice_date = invoice_date
    @debits = debits
    @color = color
  end

  def products
    @products ||= make_products
  end

  def state
    return :forget if debits.empty?
    return :retain if settled
    return :mail if color == :red

    no_invoice_required? ? :retain : :mail
  end

  private

  def make_products
    products = product_arrears + product_debits
    products = apply_balance totalables: products
    products
  end

  def product_arrears
    product_arrears = Product.arrears(account: account, date_due: invoice_date)
    product_arrears.amount.nonzero? ? [product_arrears] : []
  end

  def product_debits
    debits.map do |debit|
      Product.new debit.to_debitable
    end
  end

  def apply_balance(totalables:)
    sum = 0
    totalables.map do |totalable|
      totalable.balance = sum += totalable.amount
      totalable
    end
  end

  def no_invoice_required?
    product_debits.to_a.count { |debit| !debit.automatic? }.zero?
  end

  def final_balance
    return 0 if products.empty?

    products.last.balance
  end

  def settled
    final_balance <= 0
  end
end
