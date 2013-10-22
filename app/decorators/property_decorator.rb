class PropertyDecorator
  attr_reader :property

  def initialize property
    @property = property
  end

  def address_lines
    address_lines = []
    address_lines << property.entities.full_name
    address_lines << flat_line if address.flat_no.present?
    address_lines << address.house_name if address.house_name.present?
    address_lines << road_line
    address_lines << address.district if address.district.present?
    address_lines << address.town if address.town.present?
    address_lines << address.county if address.county.present?
    address_lines << address.postcode if address.postcode.present?
    address_lines
  end

  def reduced_address_lines
    address_lines = []
    address_lines << property.entities.full_name
    address_lines << flat_line if address.flat_no.present?
    address_lines << address.house_name if address.house_name.present?
    address_lines << road_line
    address_lines << address.town if address.town.present?
    address_lines
  end

  def start_address
    [address.flat_no, address.house_name, address.road_no, address
    .road].reject(&:blank?).join('  ')
  end

  private

    def flat_line
      "Flat #{address.flat_no}".strip
    end

    def road_line
      "#{address.road_no} #{address.road}".strip
    end

    def method_missing method_name, *args, &block
      @property.send method_name, *args, &block
    end

    def respond_to_missing? method_name, include_private = false
      @property.respond_to?(method_name, include_private) || super
    end
end
