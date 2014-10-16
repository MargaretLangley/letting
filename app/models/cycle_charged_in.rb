####
#
# CycleChargedIn
#
# Join table to allow relationship between charge_cycle and charged_in
#
class CycleChargedIn < ActiveRecord::Base
  belongs_to :charge_cycle, inverse_of: :cycle_charged_ins
  belongs_to :charged_in, inverse_of: :cycle_charged_ins

  validates :charge_cycle, :charged_in, presence: true

  before_save :include_parent_params

  def include_parent_params
    self.charge_cycle_id = charge_cycle.id
  end
end
