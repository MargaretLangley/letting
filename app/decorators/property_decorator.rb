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

  def address_name
    source.entities.full_name
  end

  def address_lines
    address_lines = []
    address_lines << flat_line if flat_house_line.present?
    address_lines << road_line
    address_lines << address.district if address.district?
    address_lines << address.town if address.town?
    address_lines << address.county if address.county?
    address_lines << address.postcode if address.postcode?
    address_lines
  end

  def abbreviated_address
    flat_house_line.blank? ? road_line : flat_line
  end

  private

  def flat_line
    flat_house_line.present? ? "Flat #{flat_house_line}" : nil
  end

  def house_name
    address.house_name? ? address.house_name : nil
  end

  def road_line
    "#{address.road_no} #{address.road}".strip
  end

  def flat_house_line
    "#{address.flat_no} #{address.house_name}".strip
  end
end
