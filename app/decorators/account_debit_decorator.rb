require_relative '../../lib/modules/method_missing'

class AccountDebitDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

  attr_accessor :balance

  def initialize debit
    @source = debit
  end

  def charge_type
    @source.charge_type
  end

  def date
    I18n.l @source.on_date, format: :short
  end

  def due
    number_with_precision(@source.amount, precision: 2)
  end

  def payment
    ''
  end

  def amount
    @source.amount
  end
end
