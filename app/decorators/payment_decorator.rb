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
  attr_reader :source

  def initialize payment
    @source = payment
  end

  def prepare_for_form
    @source.prepare_for_form
    @source.amount = outstanding if amount.blank?
  end

  def submit_message
    @source.new_record? ?  'pay total'  : 'update'
  end

  private

  def method_missing method_name, *args, &block
    @source.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @source.respond_to?(method_name, include_private) || super
  end
end
