require_relative '../../lib/import/errors'
# rubocop: disable Rails/Output

####
#
# ChargesMatcher
#
# Matching only needed during the import process
#
# This is a service object for Charges it allows a charge to match
# an imported charge. Matching import charges should not be the concern
# of the Charge object. The import process will happen until the migration
# to the new system is complete - the import code is then retired.
#
####
#
class ChargeStructureMatcher
  @charge_structure = nil
  def initialize charge_row
    @charge_row = charge_row
    @charge_structure = \
      ChargeStructure.new(charged_in_id: charge_row.charged_in_id)
    @charge_row.each do |day, month|
      @charge_structure.due_ons.build(day: day, month: month)
    end
  end

  def id
    puts 'ChargeStructures table empty' unless ChargeStructure.any?
    found_structure = find unless find.nil?
    fail DB::ChargeStuctureUnknown unless found_structure
    found_structure.id
  end

  private

  def find
    ChargeStructure.all.find do |structure|
      structure == @charge_structure
    end
  end
end
