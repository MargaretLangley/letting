require_relative '../../lib/modules/method_missing'

class CreditDecorator
  include MethodMissing
  attr_reader :source

  def initialize credit
    @source = credit
  end

  def prepare_for_form
    self.amount = pay_off_debit if amount.blank?
  end
end