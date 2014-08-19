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
  include Comparable
  validates :charge_cycle, :charged_in, presence: true
  has_one :charge, inverse_of: :charge_structure

  belongs_to :charge_cycle
  # charge_cycle_cycle
  delegate :name, to: :charge_cycle, prefix: true
  # charged_in_name
  belongs_to :charged_in, inverse_of: :charge_structure
  delegate :name, to: :charged_in, prefix: true

  delegate :due_dates, to: :charge_cycle

  # Convention is == is Matching on values rather than object structure
  # <=> is called in the implementation of ==
  # Compares charge_in_id and then each due_on's day and month
  #
  def <=> other
    return nil unless other.is_a?(self.class)
    [charged_in_id, charge_cycle_id] <=>
    [other.charged_in_id, other.charge_cycle_id]
  end
end
