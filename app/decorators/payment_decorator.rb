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

  def initialize payment, args = {}
    @source = payment
    @human_ref = args[:human_ref]
  end

  def prepare_for_form
    @source.prepare
  end

  def credits_decorated
    @source.credits.map { |d| CreditDecorator.new d }.sort_by(&:charge_type)
  end

  def property_decorator
    PropertyDecorator.new @source.account.property
  end

  def submit_message
    @source.new_record? ?  'pay total'  : 'update'
  end
end
