# ChargeStructure
#
# Contains the information which is shared between charges.
#
# Charges are made out of unique information and information shared between
# many charges - for example charges occur on only a few days of the year
#
#
# ChargeStructure contain due_ons - which know when a charge becomes due.
# Charge cycle is converts the id into readable month cycle (1 is Mar/Sep)
#
#
#  KEEP CHARGE STRUCTURE UNTIL charge_cycle can deliver
#  ranges for arrears and advance etc.
#  At this point ...
#  charge belongs_to charged_in
#  charge belongs_to charge_cycle
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
