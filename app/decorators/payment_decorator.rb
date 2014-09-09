require_relative '../../lib/modules/method_missing'
####
#
# PaymentDecorator
#
# Adds behavior to the payment object
#
# Used when the payment has need for behviour outside of the core
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
  attr_reader :source

  def initialize payment
    @source = payment
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
end
