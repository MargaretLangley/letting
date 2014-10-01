####
# ChargeCycle
#
# Represents the repeated dates a charge becomes due in the year
#
# Charges have one of a few number of patterns of repeated due_dates.
# A charge cycle has a name identifier and a number of the repeated dates.
# A charge belongs to a ChargeCycle and a ChargeCycle has many charges.
#
# ChargeCycle has many due_ons (the dates when a charge happens, becomes due)
#
####
#
class ChargeCycle < ActiveRecord::Base
  include Comparable
  validates :name, presence: true
  validates :order, presence: true
  validates :cycle_type, inclusion: { in: %w(term monthly) }
  validates :cycle_type, presence: true
  validates :due_ons, presence: true
  has_many :charges, inverse_of: :charge_cycle

  has_many :charged_ins, through: :cycle_charged_ins
  has_many :cycle_charged_ins, dependent: :destroy
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  before_validation :clear_up_form

  delegate :between, to: :due_ons
  delegate :clear_up_form, to: :due_ons

  def monthly?
    cycle_type == 'monthly'
  end

  def prepare
    due_ons.prepare type: cycle_type
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [due_ons.sort] <=> [other.due_ons.sort]
  end
end
