class AccountCreditDecorator
  include ActionView::Helpers::NumberHelper

  def initialize credit
    @credit = credit
  end

  def charge_type
    @credit.debit.type
  end

  def date
    I18n.l @credit.on_date, format: :short
  end

  def due
    ''
  end

  def payment
    number_with_precision(@credit.amount, precision: 2)
  end

  def balance
    -@credit.amount
  end

  private

  def method_missing method_name, *args, &block
    @credit.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @credit.respond_to?(method_name, include_private) || super
  end
end
