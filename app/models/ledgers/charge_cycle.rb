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
  validates :period_type, inclusion: { in: %w(term monthly) }
  validates :period_type, presence: true
  validates :due_ons, presence: true
  has_many :charges, inverse_of: :charge_cycle

  has_many :charged_ins, through: :cycle_charged_ins
  has_many :cycle_charged_ins, dependent: :destroy
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  before_validation :clear_up_form

  delegate :clear_up_form, to: :due_ons

  def monthly?
    period_type == 'monthly'
  end

  def prepare
    due_ons.prepare type: period_type
  end

  def due_between? billing_period
    due_ons.due_between?(billing_period).map(&:make_date).to_a
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [due_ons.sort] <=> [other.due_ons.sort]
  end

  def billing_period(charged_in:, billed_on:)
    RepeatRange.new(name: charged_in,
                    dates: due_ons.map(&:make_date),
                    billed_on: billed_on).billing_period
  end
end
