require_relative '../../lib/modules/method_missing'

class CreditDecorator
  include MethodMissing
  attr_reader :source

  def initialize payment
    @source = payment
  end

  def prepare_for_form
    self.amount = outstanding if amount.blank?
  end

  def clear_up_form
    self.mark_for_destruction if amount.nil? || amount.round(2) == 0
  end
end