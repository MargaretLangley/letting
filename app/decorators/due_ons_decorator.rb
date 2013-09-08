class DueOnsDecorator
  attr_reader :dueons

  def initialize due_ons
    @due_ons = due_ons
  end

  def id index
    "property_charge_#{index}"
  end

  def by_date
    @due_ons.to_a.take(DueOns::MAX_DISPLAYED_DUE_ONS)
  end

  def every_month
    @due_ons.to_a.take(1)
  end

  def method_missing method_name, *args, &block
    @due_ons.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @due_ons.respond_to?(method_name, include_private) || super
  end
end