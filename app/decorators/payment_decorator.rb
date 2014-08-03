require_relative '../../lib/modules/method_missing'
####
#
# PropertyDecorator
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

  # Import for finding an account object but otherwise has no
  # role in the payment - hence decorator.
  attr_accessor :human_ref

  def initialize(payment, human_ref:)
    @source = payment
    @human_ref = human_ref
    # Hackfix to get credits negative when saving in the payments
    # controller - users like to work with postive numbers but credits
    # are negative - so need to reverse sign before credit saved.
    @source.credits.each do |credit|
      credit.amount *= -1
    end
  end

  def prepare_for_form
    @source.prepare
  end

  # Hackfix to get credits positive when presenting payment credits
  # to the user (actually negative) - so we change the sign here.
  def credits_decorated
    @source.credits.map do |credit|
      credit.amount *= -1
      CreditDecorator.new credit
    end.sort_by(&:charge_type)
  end

  def property_decorator
    PropertyDecorator.new @source.account.property
  end
end
