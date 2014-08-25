require_relative '../../lib/import/errors'
# rubocop: disable Rails/Output

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
