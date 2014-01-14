require_relative '../../lib/modules/method_missing'

class AccountCreditDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

  def initialize credit
    @source = credit
  end

  def charge_type
    @source.charge_type
  end

  def date
    I18n.l @source.on_date, format: :short
  end

  def due
    ''
  end

  def payment
    number_with_precision(@source.amount, precision: 2)
  end

  def balance
    -@source.amount
  end
end
