require_relative '../../lib/modules/method_missing'

###
#
# AccountCreditDecorator
#
# Adds display logic to the credit business object.
#
##
#
class AccountCreditDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

  attr_accessor :running_balance

  def initialize credit
    @source = credit
  end

  def charge_type
    @source.charge_type
  end

  def date
    I18n.l @source.on_date, format: :short
  end

  def description
    'Payment'
  end

  def due
    ''
  end

  def payment
    number_with_precision(-@source.amount, precision: 2)
  end
end
