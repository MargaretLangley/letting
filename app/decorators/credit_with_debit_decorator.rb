require_relative '../../lib/modules/method_missing'

class CreditWithDebitDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing
  attr_reader :source

  def initialize credit
    @source = credit
  end

  def prepare_for_form
    self.amount = pay_off_debit if amount.blank?
  end

  def amount
    number_with_precision(@source.amount,precision: 2)
  end

  private

  def pay_off_debit
    @source.pay_off_debit
  end

  def debit
    @source.debit
  end
end
