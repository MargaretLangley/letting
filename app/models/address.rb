####
#
# Address
#
# Why does the class exist?
#
# Represents an address of either a property or a person in the system.
#
# How does it fit in the larger system?
#
# Property, Billing Addresses (Agents) and Clients all require and has_one
# address.
#
####
#
class Address < ActiveRecord::Base
  MIN_STRING = 4
  MAX_STRING = 64
  MAX_NUMBER = 10
  MIN_POSTCODE = 6
  MAX_POSTCODE = 8
  belongs_to :addressable, polymorphic: true
  validates :county, :road, presence: true
  validates :flat_no, :road_no, length: { maximum: MAX_NUMBER },
                                allow_blank: true
  validates :house_name, length: { maximum: MAX_STRING }, allow_blank: true
  validates :road,       length: { maximum: MAX_STRING }
  validates :district, :town, length: { minimum: MIN_STRING,
                                        maximum: MAX_STRING },
                              allow_blank: true
  validates :county,   length: { minimum: MIN_STRING, maximum: MAX_STRING }
  validates :postcode, length: { minimum: MIN_POSTCODE,
                                 maximum: MAX_POSTCODE },
                       allow_blank: true

  def address_lines
    address_lines = []
    if flat_house_line.present?
      address_lines << flat_line
    end
    address_lines << road_line
    address_lines << district if district?
    address_lines << town if town?
    address_lines << county if county?
    address_lines << postcode if postcode?
    address_lines
  end

  def abbreviated_address
    flat_house_line.blank? ? road_line : flat_line
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  def copy_approved_attributes
    attributes.except(*ignored_attrs)
  end

  def clear_up_form
    mark_for_destruction
  end

  private

  def flat_line
    flat_house_line.present? ? "Flat #{flat_house_line}" : nil
  end

  def road_line
    "#{road_no} #{road}".strip
  end

  def flat_house_line
    "#{flat_no} #{house_name}".strip
  end

  def ignored_attrs
    %w[id addressable_id addressable_type created_at updated_at]
  end
end
