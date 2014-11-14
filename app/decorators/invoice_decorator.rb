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
####
#
class InvoiceDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing
  attr_reader :source

  def initialize invoice
    @source = invoice
  end

  def invoice_date
    I18n.l @source.invoice_date, format: :short
  end

  def billing_agent
    @source.billing_address.lines.first
  end

  def billing_first_address_line
    @source.billing_address.lines.second
  end

  def products_display
    "#{@source.products.first.charge_type} "\
    "£#{number_with_precision(@source.products.first.amount, precision: 2)}"
  end

  def earliest_date_due
    I18n.l @source.earliest_date_due, format: :short
  end
end
