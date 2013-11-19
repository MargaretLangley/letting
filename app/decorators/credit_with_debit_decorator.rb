require_relative '../../lib/modules/method_missing'

class CreditWithDebitDecorator
  include MethodMissing
  attr_reader :source

  def initialize credit
    @source = credit
  end

  def prepare_for_form
    self.amount = pay_off_debit if amount.blank?
  end

  def debit_decorator
    DebitDecorator.new debit
  end

  private

  def pay_off_debit
    @source.pay_off_debit
  end

  def debit
    @source.debit
  end
end
