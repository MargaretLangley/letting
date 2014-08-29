require_relative '../../lib/import/errors'
# rubocop: disable Rails/Output

####
#
# ChargeCycleMatcher
#
# Identifies a collection of due_ons as a specific ChargeCycle.
#
# During the import of the legacy acc_info file the import_charge code presents
# ChargeRow with a number of reoccuring dates (day and month that occur every
# year) - these dates are converted into an id that matches a charge cycle. This
# is the class responsible for the conversion.
#
####
#
class ChargeCycleMatcher
  def initialize charge_row
    @unidentified_charge_cycle = ChargeCycle.new(name: 'unknown')
    charge_row.each do |day, month|
      @unidentified_charge_cycle.due_ons.build(day: day, month: month)
    end
  end

  def id
    return puts 'ChargeCycle table has no records' unless ChargeCycle.any?
    found_structure = find
    fail DB::ChargeCycleUnknown unless found_structure
    found_structure.id
  end

  private

  def find
    ChargeCycle.all.find do |structure|
      structure.due_ons.sort == @unidentified_charge_cycle.due_ons.sort
    end
  end
end
