require_relative '../../lib/import/errors'
# rubocop: disable Rails/Output

####
#
# CycleMatcher
#
# Identifies a collection of due_ons as a specific Cycle.
#
# During the import of the legacy acc_info file the import_charge code presents
# ChargeRow with a number of reoccurring dates (day and month that occur every
# year) - these dates are converted into an id that matches a charge cycle. This
# is the class responsible for the conversion.
#
####
#
class CycleMatcher
  def initialize(day_months:)
    @unidentified_cycle = Cycle.new(name: 'unknown')
    day_months.each do |day, month|
      @unidentified_cycle.due_ons.build(day: day, month: month)
    end
  end

  def id
    return warn 'Cycle table has no records' unless Cycle.any?
    found_structure = find
    fail DB::CycleUnknown unless found_structure
    found_structure.id
  end

  private

  def find
    Cycle.all.find do |structure|
      structure.due_ons.sort == @unidentified_cycle.due_ons.sort
    end
  end
end
