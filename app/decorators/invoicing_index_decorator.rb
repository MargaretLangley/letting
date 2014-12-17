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
####
#
class InvoicingIndexDecorator
  include ActionView::Helpers::NumberHelper
  include SalientDate
  include MethodMissing
  attr_reader :source

  def invoicing
    @source
  end

  def initialize invoicing
    @source = invoicing
  end

  def created_at
    I18n.l invoicing.created_at, format: :human
  end

  def period_between
    salient_date_range start_date: invoicing.period_first,
                       end_date: invoicing.period_last
  end
end
