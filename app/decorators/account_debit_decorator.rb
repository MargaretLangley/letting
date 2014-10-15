require_relative '../../lib/modules/method_missing'

###
#
# AccountDebitDecorator
#
# Adds display logic to the debit business object.
#
##
#
class AccountDebitDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

  attr_accessor :running_balance

  def initialize debit
    @source = debit
  end

  def charge_type
    @source.charge_type
  end

  def date
    I18n.l @source.on_date, format: :short
  end

  def description
    "#{I18n.l @source.period.first, format: :short} to "\
    "#{I18n.l @source.period.last, format: :short}"
  end

  def due
    number_with_precision(@source.amount, precision: 2)
  end

  def payment
    ''
  end
end
