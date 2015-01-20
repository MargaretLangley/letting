require_relative '../../lib/modules/method_missing'

###
#
# AccountCreditDecorator
#
# Adds display logic to the credit business object.
#
# rubocop: disable Style/TrivialAccessors
##
#
class AccountCreditDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper
  include NumberFormattingHelper

  attr_accessor :running_balance

  def credit
    @source
  end

  def initialize credit
    @source = credit
  end

  delegate :charge_type, to: :credit

  def date
    I18n.l credit.at_time, format: :short
  end

  def description
    'Payment'
  end

  def due
    ''
  end

  def payment
    to_decimal credit.amount
  end

  def balance
    -credit.amount
  end
end
