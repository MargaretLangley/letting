require_relative '../../lib/modules/method_missing'

class CreditInAdvanceDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing
  attr_reader :source

  def initialize credit
    @source = credit
  end

  def prepare_for_form
  end

  def amount
    number_with_precision(source.amount,precision: 2)
  end

  def expected_amount
    number_to_currency charge_info.amount
  end

  def expected_date
    charge_info.on_date
  end

  def owing_amount
    number_to_currency 0
  end

  private

  def charge_info
    @charge_info ||= charge.first_chargeable Date.current..Date.current + 1.years
  end

  def charge
    source.charge
  end
end