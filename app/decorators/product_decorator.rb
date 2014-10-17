###
# ProductDecorator
#
# Adds display logic to the charge business object.
#
# rubocop: disable Style/TrivialAccessors
##
#
class ProductDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

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
    number_with_precision(product.amount, precision: 2)
  end

  def balance
    number_with_precision(product.balance, precision: 2)
  end
end
