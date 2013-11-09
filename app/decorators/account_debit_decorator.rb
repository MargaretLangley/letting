

class AccountDebitDecorator
  include ActionView::Helpers::NumberHelper

  def initialize debit
    @debit = debit
  end

  def charge_type
    @debit.type
  end

  def date
    I18n.l @debit.on_date, format: :short
  end

  def due
    number_with_precision(@debit.amount,precision: 2)
  end

  def payment
    ''
  end

  def balance
    @debit.amount
  end

  private

  def method_missing method_name, *args, &block
    @debit.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @debit.respond_to?(method_name, include_private) || super
  end
end