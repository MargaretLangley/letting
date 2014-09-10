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
  validates :period_type, presence: true
  validates :due_ons, presence: true
  has_many :charges, inverse_of: :charge_cycle

  has_many :charged_ins, through: :cycle_charged_ins
  has_many :cycle_charged_ins, dependent: :destroy
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  before_validation :clear_up_form

  delegate :prepare, to: :due_ons
  delegate :clear_up_form, to: :due_ons

  after_initialize do
    self.period_type ||= 'term'
  end

  def due_between? date_range
    due_ons.due_between?(date_range).to_a
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [due_ons.sort] <=> [other.due_ons.sort]
  end

  # return the range for the due_on/date
  # currently just returns a matched date but will
  # eventually be a date
  def range_on date
    @range ||= RepeatRange.new \
                 dates: due_ons.due_between?(Time.now.beginning_of_year..\
                                            Time.now.end_of_year)
    found_date = @range.find date
    found_date ? found_date.date : :missing_due_on
  end
end
