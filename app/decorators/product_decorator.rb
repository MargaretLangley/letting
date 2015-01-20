###
# ProductDecorator
#
# Adds display logic to the product business object used by invoice_page1
# to output the data for an invoice.
#
# rubocop: disable Style/TrivialAccessors
##
#
class ProductDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper
  include NumberFormattingHelper

  def product
    @source
  end

  def initialize source_product
    @source = source_product
  end

  def date_due
    I18n.l product.date_due, format: :short
  end

  def period
    return '&nbsp;'.html_safe unless product.period.first && product.period.last
    "#{I18n.l product.period.first, format: :short} - "\
    "#{I18n.l product.period.last, format: :short}"
  end

  def amount
    to_decimal product.amount
  end

  def amount_on_time
    "£#{amount} on #{date_due}"
  end

  def balance
    to_decimal product.balance
  end
end
