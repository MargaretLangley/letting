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
  validates :due_ons, presence: true
  has_many :charges, inverse_of: :charge_cycle
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true

  delegate :prepare, to: :due_ons

  def due_dates date_range
    due_ons.due_dates(date_range).to_a
  end
    # charge_cycle_create id: 1
    # charge_cycle_create name: 'Jan/July'
    # charge_cycle_create order: 1

  def <=> other
    return nil unless other.is_a?(self.class)
    [due_ons.sort] <=> [other.due_ons.sort]
  end

  # return the range for the due_on/date
  # currently just returns a matched date but will
  # eventually be a date
  def range_on date
    @range ||= RepeatRange.new \
                 dates: due_ons.due_dates(Time.now.beginning_of_year..\
                                          Time.now.end_of_year)
    found_date = @range.find date
    found_date ? found_date.date : :missing_due_on
  end

  delegate :clear_up_form, to: :due_ons

  # Require this if we are creating and editing charge_structure
  # Remove this if we don't

  # def clear_up_form
  # # FIX_CHARGE
  #   mark_for_destruction unless edited?
  #   due_ons.clear_up_form
  # end

  # def empty?
  # FIX_CHARGE
  # maybe should include this - not sure &&
  #  due_ons.empty?
  # end
end
