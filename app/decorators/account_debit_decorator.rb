require_relative '../../lib/modules/method_missing'

class AccountDebitDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

  def initialize debit
    @source = debit
  end

  def charge_type
    @source.type
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

  def balance
    @source.amount
  end
end
