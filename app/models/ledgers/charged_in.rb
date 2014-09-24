####
#
# ChargedIn
#
# Invoice payment order - advance, arrears or mid-term
# This is a collection that the Charge object references.
#
####
#
class ChargedIn < ActiveRecord::Base
  has_many :charges, inverse_of: :charged_in

  has_many :charge_cycles, through: :cycle_charged_ins
  has_many :cycle_charged_ins, dependent: :destroy
  validates :name, presence: true
  validates :name, inclusion: { in: %w(Advance Arrears Mid-Term) }
end
