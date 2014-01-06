require_relative '../../lib/modules/method_missing'
####
#
# PropertyDecorator
#
# Adds behavior to the property object
#
# Used when the property has need for behviour outside of the core
# of the model. Specifically for display information.
#
####
#
class PropertyDecorator
  include MethodMissing
  attr_reader :source

  def initialize property
    @source = property
  end

  def client_ref
    client && client.human_ref
  end

  def address_lines
    address_lines = []
    address_lines << source.entities.full_name
    address_lines << flat_line if address.flat_no?
    address_lines << address.house_name if address.house_name?
    address_lines << road_line
    address_lines << address.district if address.district?
    address_lines << address.town if address.town?
    address_lines << address.county if address.county?
    address_lines << address.postcode if address.postcode?
    address_lines
  end

  def reduced_address_lines
    address_lines = []
    first_line = source.entities.full_name
    second_line = [flat_line, address.house_name, road_line].compact.join" "
    address_lines.push *[ first_line, second_line]
  end

  def start_address
    [address.flat_no, address.house_name, address.road_no, address
    .road].reject(&:blank?).join('  ')
  end

  private

    def flat_line
      "Flat #{address.flat_no}".strip if address.flat_no?
    end

    def road_line
      "#{address.road_no} #{address.road}".strip
    end
end
