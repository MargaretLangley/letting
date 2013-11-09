class AccountBalanceDecorator
  include ActionView::Helpers::NumberHelper

  attr_reader :balance
  attr_reader :on_date

  def initialize balance, date
    @balance = balance
    @on_date = date
  end

  def charge_type
    'Balance carried forward'
  end

  def date
    I18n.l @on_date, format: :short
  end

  def due
    ''
  end

  def payment
    ''
  end
end
