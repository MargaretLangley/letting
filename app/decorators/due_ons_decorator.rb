####
#
# DueOnsDecorator
#
# Provides a interface to the due_ons to keep view logic away from business
# logic.
#
# Used only for due_ons - currently only in managing charges in the property
# resource.
#
# Any methods that it cannot respond to get passed to the due_ons through
# method_missing.
#
####
#
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

  def per_month
    if @due_ons.per_month?
      DueOn.new day: first_day_or_empty, month: DueOn::PER_MONTH
    else
      DueOn.new day: '', month: ''
    end
  end

  def first_day_or_empty
    @due_ons.first.present? ? @due_ons.first.day : ''
  end

  def hidden_side? side
    if per_month?
      side == DueOn::PER_MONTH ? '' : 'hidden'
    else
      side == DueOn::ON_DATE ? '' : 'hidden'
    end
  end

  def method_missing method_name, *args, &block
    @due_ons.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @due_ons.respond_to?(method_name, include_private) || super
  end
end
