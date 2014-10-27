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
  has_many :cycles, inverse_of: :charged_in

  validates :name, presence: true
  validates :name, inclusion: { in: %w(Advance Arrears Mid-Term) }

  def to_s
    "charged_in: #{name[0..2]}"
  end
end
