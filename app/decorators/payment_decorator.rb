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
  def initialize payment
    @payment = payment
  end

  def submit_message
    @payment.new_record? ?  'pay total'  : 'update'
  end

  private

  def method_missing method_name, *args, &block
    @payment.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @payment.respond_to?(method_name, include_private) || super
  end
end
