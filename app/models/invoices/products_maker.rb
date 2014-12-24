###
# ProductsMaker
#
# Assembles products from arrears and from the invoiceable debits.
# Calculates products, total_arrears and earliest date for a product.
#
# Products, basically, an account item for the invoice.
#
# @transaction - the debits created during the invoice period.
#
# @arrears - the amount the account is in arrears
#
# @invoice_date - the date the invoice is dated with. Used by the arrears
#                 product item.
#
###
#
class ProductsMaker
  attr_reader :arrears, :invoice_date, :transaction
  def initialize(transaction:, arrears:, invoice_date:)
    @transaction = transaction
    @invoice_date = invoice_date
    @arrears = arrears
  end

  # Returns the information required for an invoice
  # products - are the account items of the invoice
  #
  def invoice(*)
    products
  end

  # If we any debits are due for this invoice.
  #
  def debits?
    product_debits.present?
  end

  # Wrapper for the arguments required for an Arrears product item.
  # All the other product items are taken from the debit.
  #
  def self.arrears(date_due:, amount:)
    Product.new charge_type: ChargeTypes::ARREARS,
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
