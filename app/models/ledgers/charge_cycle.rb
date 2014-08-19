class ChargeCycle < ActiveRecord::Base
  include Comparable
  validates :due_ons, presence: true
  has_many :charge_structures
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true

  delegate :prepare, to: :due_ons

  def due_dates date_range
    due_ons.due_dates(date_range).to_a
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [due_ons.sort] <=> [other.due_ons.sort]
  end

  delegate :clear_up_form, to: :due_ons

  # Require this if we are creating and editing charge_structure
  # Remove this if we don't

  # def clear_up_form
  # # FIX_CHARGE
  #   mark_for_destruction unless edited?
  #   due_ons.clear_up_form
  # end

  # def empty?
  # FIX_CHARGE
  # maybe should include this - not sure &&
  #  due_ons.empty?
  # end
end
