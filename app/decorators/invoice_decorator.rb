require_relative '../../lib/modules/method_missing'
####
#
# InvoiceDecorator
#
# Adds behaviour to the property object
#
# Used when the property has need for behaviour outside of the core
# of the model. Specifically for display information.
#
# rubocop: disable Style/TrivialAccessors
#
####
#
class InvoiceDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing

  def invoice
    @source
  end

  def initialize invoice
    @source = invoice
  end

  def invoice_date
    I18n.l invoice.invoice_date, format: :short
  end

  def billing_agent
    invoice.billing_address.lines.first
  end

  def billing_first_address_line
    invoice.billing_address.lines.second
  end

  def products_display
    return 'No charges' if invoice.products.drop_arrears.size.zero?

    invoice.products.drop_arrears.first(2).map do |product|
      "#{product.charge_type} "\
        "£#{number_with_precision(product.amount, precision: 2)}"
    end.join ', '
  end

  def earliest_date_due
    if invoice.earliest_date_due
      I18n.l invoice.earliest_date_due, format: :short
    else
      invoice_date
    end
  end
end
