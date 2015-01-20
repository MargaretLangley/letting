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
  include NumberFormattingHelper

  def credit
    @source
  end

  def initialize credit
    @source = credit
  end

  def prepare_for_form
  end

  def amount
    to_decimal credit.amount
  end

  def owing
    to_decimal charge_debt
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
    Debit.debt_on_charge(charge_id)
  end
end
