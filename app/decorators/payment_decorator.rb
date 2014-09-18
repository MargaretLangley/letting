require_relative '../../lib/modules/method_missing'
####
#
# PaymentDecorator
#
# Adds behaviour to the payment object
#
# Used when the payment has need for behaviour outside of the core
# of the model. Specifically for display information.
#
# The main issue is with credit signs. The accounts system maintains negative
# credits. However, the users don't want to think about signs - they want to
# enter data. The decorator changes the sign when displaying data and we change
# it back before saving it.
#
# Sign changing methods
# credits_decorated  - negative to positive.
# initializer        - positive to negative.
#
####
#
class PaymentDecorator
  include MethodMissing
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActionView::Helpers::NumberHelper
  attr_reader :source

  def initialize payment
    @source = payment
  end

  def human_ref
    return '-' unless @source.account
    @source.account.property.human_ref
  end

  def prepare_for_form
    @source.prepare
  end

  def credits_decorated
    @source.credits.map do |credit|
      CreditDecorator.new credit
    end.sort_by(&:charge_type)
  end

  def property_decorator
    PropertyDecorator.new @source.account.property
  end

  def last_amount
    return '-' if last_payment == :no_last_payment
    number_to_currency last_payment.negate.amount
  end

  def last_human_ref
    return '-' if last_payment == :no_last_payment
    last_payment.account.property.human_ref
  end

  def todays_takings
    number_to_currency Payments.on
                               .map(&:negate)
                               .map(&:amount).inject(0, &:+)
  end

  private

  def last_payment
    return :no_last_payment if Payments.last == :no_last_payment
    Payments.last
  end
end
