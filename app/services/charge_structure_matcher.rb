require_relative '../../lib/import/errors'
# rubocop: disable Rails/Output

class ChargeStructureMatcher
  def initialize(charged_in_id:, charge_cycle_id:)
    @charged_in_id = charged_in_id
    @charge_cycle_id = charge_cycle_id
  end

  def id
    puts 'ChargeStructures table empty' unless ChargeStructure.any?
    found = find
    unless found
      p "fail find charged_in: #{@charged_in_id}, Cycle: #{@charge_cycle_id}"
      fail DB::ChargeStuctureUnknown
    end
    found.id
  end

  private

  def find
    ChargeStructure.find_by(charged_in_id: @charged_in_id,
                            charge_cycle_id: @charge_cycle_id)
  end
end
