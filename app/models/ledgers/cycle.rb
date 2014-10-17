####
# Cycle
#
# Represents the repeated dates a charge becomes due in the year
#
# Charges have one of a few number of patterns of repeated due_dates.
# A charge cycle has a name identifier and a number of the repeated dates.
# A charge belongs to a Cycle and a Cycle has many charges.
#
# Cycle has many due_ons (the dates when a charge happens, becomes due)
#
####
#
class Cycle < ActiveRecord::Base
  include Comparable
  validates :name, presence: true
  validates :order, presence: true
  validates :cycle_type, inclusion: { in: %w(term monthly) }
  validates :cycle_type, presence: true
  validates :due_ons, presence: true
  has_many :charges, inverse_of: :cycle

  has_many :charged_ins, through: :cycle_charged_ins
  has_many :cycle_charged_ins, inverse_of: :cycle, dependent: :destroy
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

  def to_s
    "cycle: #{name}, type: #{cycle_type}, " + due_ons.to_s
  end
end
