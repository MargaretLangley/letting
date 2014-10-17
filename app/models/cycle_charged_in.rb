####
#
# CycleChargedIn
#
# Join table to allow relationship between cycle and charged_in
#
class CycleChargedIn < ActiveRecord::Base
  belongs_to :cycle, inverse_of: :cycle_charged_ins
  belongs_to :charged_in, inverse_of: :cycle_charged_ins

  validates :cycle, :charged_in, presence: true

  before_save :include_parent_params

  def include_parent_params
    self.cycle_id = cycle.id
  end
end
