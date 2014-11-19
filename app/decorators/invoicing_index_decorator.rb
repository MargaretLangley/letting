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
class InvoicingIndexDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing
  attr_reader :source

  def initialize invoicing
    @source = invoicing
  end

  def created_at
    I18n.l @source.created_at, format: :human
  end

  def period_first
    I18n.l @source.period_first, format: :short
  end

  def period_last
    I18n.l @source.period_last, format: :short
  end
end
