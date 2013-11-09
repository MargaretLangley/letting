class AccountBalanceDecorator
  include ActionView::Helpers::NumberHelper

  attr_reader :balance

  def initialize balance, date
    @balance = balance
    @date = date
  end

  def charge_type
    'Balance carried forward'
  end

  def date
    I18n.l @date, format: :short
  end

  def due
    ''
  end

  def payment
    ''
  end
end
