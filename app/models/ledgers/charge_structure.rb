# ChargeStructure
#
# The Information required to know when a debit is created for a charge
#
# A charge is responsible for an amount and a time period it is active.
# When a charge is due is handled by charge_structure.
#
# ChargeStructure contain due_ons - which know when a charge becomes due.
# Charge cycle is converts the id into readable month cycle (1 is Mar/Sep)
#
#
#
class ChargeStructure < ActiveRecord::Base
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  validates :due_ons, presence: true
  has_one :charge, inverse_of: :charge_structure
  belongs_to :charge_cycle
  belongs_to :charged_in, inverse_of: :charge_structure

  delegate :due_dates, to: :due_ons

  delegate :prepare, to: :due_ons

  delegate :clear_up_form, to: :due_ons

  # charge_cycle_cycle
  delegate :cycle, to: :charge_cycle, prefix: true
  # charged_in_name
  delegate :name, to: :charged_in, prefix: true

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
