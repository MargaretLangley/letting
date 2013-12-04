require_relative '../../lib/modules/method_missing'

class CreditDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing
  attr_reader :source

  def initialize credit
    @source = credit
  end

  def amount
    number_with_precision(@source.amount,precision: 2)
  end

  private

  def debit
    @source.debit
  end
end
