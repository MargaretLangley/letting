require_relative '../../lib/modules/method_missing'
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
  include MethodMissing
  attr_reader :source

  def initialize due_ons
    @source = due_ons
  end

  def id index
    "property_charge_#{index}"
  end

  def by_date
    @source.to_a.take(DueOns::MAX_DISPLAYED_DUE_ONS)
  end

  def per_month
    if monthly?
      DueOn.new day: first_day_or_empty, month: DueOn::PER_MONTH
    else
      DueOn.new day: '', month: ''
    end
  end

  def first_day_or_empty
    @source.first.present? ? @source.first.day : ''
  end

  def hidden_side? side
    if monthly?
      side == DueOn::PER_MONTH ? '' : 'js-revealable'
    else
      side == DueOn::ON_DATE ? '' : 'js-revealable'
    end
  end
end
