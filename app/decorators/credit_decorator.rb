require_relative '../../lib/modules/method_missing'

###
#
# CreditDecorator
#
# Adds display logic to the credit business object.
#
# Used by payment decorator .
#
# rubocop: disable Style/TrivialAccessors
##
#
class CreditDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing

  def credit
    @source
  end

  def initialize credit
    @source = credit
  end

  def prepare_for_form
  end

  def amount
    number_with_precision(credit.amount, precision: 2)
  end

  def owing
    number_with_precision(charge_debt, precision: 2)
  end

  # payment
  # Payment amounts have different behaviour when new and when edited.
  # When new we take the amount owing as the default
  # When editing we take the amount already paid.
  #
  def payment
    credit.new_record? ? owing : amount
  end

  private

  def charge_debt
    Debit.available(charge_id).to_a.sum(&:outstanding)
  end
end
