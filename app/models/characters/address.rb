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
# Property, Agent and Clients all require and has_one
# address.
#
####
#
class Address < ActiveRecord::Base
  MIN_STRING = 2
  MAX_STRING = 64
  MAX_NUMBER = 10
  MIN_POSTCODE = 6
  MAX_POSTCODE = 20
  belongs_to :addressable, polymorphic: true
  validates :county, :road, presence: true
  validates :flat_no, :road_no,
            length: { maximum: MAX_NUMBER },
            allow_blank: true
  validates :house_name, length: { maximum: MAX_STRING }, allow_blank: true
  validates :road,       length: { maximum: MAX_STRING }
  validates :district, :nation, :town,
            length: { minimum: MIN_STRING, maximum: MAX_STRING },
            allow_blank: true
  validates :county,   length: { minimum: MIN_STRING, maximum: MAX_STRING }
  validates :postcode,
            length: { minimum: MIN_POSTCODE, maximum: MAX_POSTCODE },
            allow_blank: true

  def name_and_address name:, join: "\n"
    name + join + text(join: join)
  end

  def first_line
    flat_line || road_line
  end

  def abridged_text join: "\n"
    [flat_house_line.blank? ? road_line : flat_line,
     town.blank? ? county : town].join "#{join}"
  end

  def text join: "\n"
    address_lines.delete_if(&:empty?).join "#{join}"
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
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

  def address_lines
    [
      flat_line,
      road_line,
      district,
      town,
      county,
      postcode,
      nation
    ].compact
  end

  def ignored_attrs
    %w(id addressable_id addressable_type created_at updated_at)
  end
end
