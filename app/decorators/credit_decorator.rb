class CreditDecorator
  attr_reader :source

  def initialize payment
    @source = payment
  end

  def prepare_for_form
    self.amount = outstanding if amount.blank?
  end

  def clear_up_form
    self.mark_for_destruction if amount.nil? || amount.round(2) == 0
  end

  private

  def method_missing method_name, *args, &block
    @source.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @source.respond_to?(method_name, include_private) || super
  end
end