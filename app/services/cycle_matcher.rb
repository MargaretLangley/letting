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
  attr_reader :unidentified_cycle
  def initialize(charged_in_id:, day_months:)
    @unidentified_cycle = Cycle.new name: 'unknown',
                                    charged_in_id: charged_in_id
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
    Cycle.all.find do |cycle|
      cycle == unidentified_cycle
    end
  end
end
