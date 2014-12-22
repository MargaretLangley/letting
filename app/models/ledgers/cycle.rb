####
# Cycle
#
# Represents the repeated dates a charge becomes due in the year
#
# Charges have one of a few number of patterns of repeated due_dates.
# A cycle has a name identifier and a number of the repeated dates.
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
  validates :cycle_type, :charged_in_id, presence: true
  validates :due_ons, presence: true
  has_many :charges, class_name: 'Charge',
                     foreign_key: 'cycle_id',
                     inverse_of: :cycle

  belongs_to :charged_in, inverse_of: :cycles
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

  def between billing_period
    due_ons.between(billing_period).map do |match|
      MatchedCycle.new(match.spot, bill_period(billed_on: match.show))
    end
  end

  # required to be public for importing accounts information
  def bill_period(billed_on:)
    RangeCycle.for(name: charged_in.name,
                   dates: show_dates(year: billed_on.year))
      .duration within: billed_on
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [charged_in_id, due_ons.sort] <=> [other.charged_in_id, other.due_ons.sort]
  end

  def to_s
    "cycle: #{name}, type: #{cycle_type}, charged_in: #{charged_in_id}, " +
      due_ons.to_s
  end

  private

  def show_dates(year:)
    due_ons.map { |due_on| due_on.show_date year: year }
  end
end
